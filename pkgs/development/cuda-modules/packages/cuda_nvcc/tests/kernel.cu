// A kernel launched from host code. The tests link programs but don't run them.

__global__ void kernel(int *p) { *p = 42; }

int main() { kernel<<<1, 1>>>(nullptr); }
