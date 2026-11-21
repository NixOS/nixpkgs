// The only definitions with external linkage in this file are templates. nvcc then puts its process ID into the names
// of the entities with internal linkage, unless it is given a seed (--frandom-seed).

namespace {
__device__ __noinline__ int twice(int x) { return 2 * x; }
} // namespace

template <typename T> __global__ void kernel(T *p) { *p = static_cast<T>(twice(static_cast<int>(*p))); }

template <typename T> void launch(T *p) { kernel<T><<<1, 1>>>(p); }

template void launch<int>(int *);
template void launch<float>(float *);
