#include <cuda_runtime.h>
#include <cuda/std/version>
#include <cuda/std/type_traits>
#include <cub/version.cuh>
#include <thrust/version.h>

#if !defined(__clang__) || __clang_major__ != 18 || __clang_minor__ != 1 || __clang_patchlevel__ != 8
#error "XLA requires the pinned Clang 18.1.8 host compiler"
#endif
#if CCCL_VERSION != 3002000 || CUB_VERSION != 300200 || THRUST_VERSION != 300200
#error "The selected NVCC profile must not shadow XLA's CCCL 3.2.0 headers"
#endif
#ifdef XLA_TEST_SELECTED_OUTPUT
#include <xla-selected-output.h>
static_assert(XLA_SELECTED_OUTPUT == 964, "selected patched header was lost");
#endif
static_assert(cuda::std::is_same_v<int, int>);
__global__ void xla_cuda_header_probe(float* values) {
  values[threadIdx.x] = values[threadIdx.x] * 2.0f;
}
