#include <stdint.h>

__attribute__((noinline)) int choose(uint32_t value) {
    if (value == 0x1337U) {
        return 42;
    }
    return 7;
}

int main(int argc, char **argv) {
    (void)argv;
    return choose((uint32_t)argc);
}
