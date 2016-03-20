.PHONY: all x86 avx avx2 help

CC=g++
FLAGS=-std=c++11 -mpopcnt -O2 -Wall -pedantic -Wextra

DEPS=popcnt-*.cpp function_registry.cpp config.h
ALL=speed verify
ALL_AVX=speed_avx verify_avx
ALL_AVX2=speed_avx2 verify_avx2

all: $(ALL)

help:
	@echo "targets:"
	@echo "x86      - makes programs verify & speed (the default target)"
	@echo "avx      - makes programs verify_avx & speed_avx"
	@echo "avx2     - makes programs verify_avx2 & speed_avx2"
	@echo "run      - runs speed test for x86 code"
	@echo "run_avx2 - runs speed test for AVX code"
	@echo "run_avx2 - runs speed test for AVX2 code"


x86: $(ALL)

avx: $(ALL_AVX)

avx2: $(ALL_AVX2)

speed: $(DEPS) speed.cpp
	$(CC) $(FLAGS) -mssse3 speed.cpp -o $@

verify: $(DEPS) verify.cpp
	$(CC) $(FLAGS) -mssse3 verify.cpp -o $@

speed_avx: $(DEPS) speed.cpp
	$(CC) $(FLAGS) -mavx speed.cpp -o $@

verify_avx: $(DEPS) verify.cpp
	$(CC) $(FLAGS) -mavx verify.cpp -o $@

speed_avx2: $(DEPS) speed.cpp
	$(CC) $(FLAGS) -mavx2 -DHAVE_AVX2_INSTRUCTIONS speed.cpp -o $@

verify_avx2: $(DEPS) verify.cpp
	$(CC) $(FLAGS) -mavx2 -DHAVE_AVX2_INSTRUCTIONS verify.cpp -o $@

SIZE=10000000
ITERS=100

run: speed
	./speed $(SIZE) $(ITERS)

run_avx: speed_avx
	./speed_avx $(SIZE) $(ITERS)

run_avx2: speed_avx2
	./speed_avx2 $(SIZE) $(ITERS)

clean:
	rm -f $(ALL) $(ALL_AVX) $(ALL_AVX2)
