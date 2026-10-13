"""Run with installed PyCUDA and a real driver: python this-file.py --arch sm_89.

Use a clean environment with only Bash/coreutils on PATH to test installed NVCC
and device-runtime defaults. PTX must target an architecture supported by both
the selected toolkit and the runtime GPU; the driver links it for that GPU.
"""

import argparse

import numpy as np
import pycuda.compiler as compiler
import pycuda.driver as cuda


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--arch", required=True)
    args = parser.parse_args()
    cuda.init()
    device = cuda.Device(0)
    context = device.make_context()
    try:
        module = compiler.DynamicSourceModule(
            r'''
            #include <curand_kernel.h>
            #include <cuda/std/type_traits>
            static_assert(cuda::std::is_same<float, float>::value, "CCCL");
            extern "C" __global__ void saxpy(int n, float a, const float *x, float *y) {
                int i = blockIdx.x * blockDim.x + threadIdx.x;
                if (i < n) y[i] = a * x[i] + y[i];
            }
            extern "C" __global__ void launch(int n, float a, const float *x,
                                            float *y, int *status) {
                if (blockIdx.x == 0 && threadIdx.x == 0) {
                    saxpy<<<(n + 255) / 256, 256>>>(n, a, x, y);
                    *status = (int) cudaGetLastError();
                }
            }
            ''',
            arch=args.arch, no_extern_c=True,
        )
        count = 4097
        a = np.float32(1.75)
        x = np.arange(count, dtype=np.float32) * np.float32(0.25)
        y = np.arange(count, dtype=np.float32) * np.float32(0.125)
        expected = a * x + y
        status = np.array([-1], dtype=np.int32)
        module.get_function("launch")(
            np.int32(count), a, cuda.In(x), cuda.InOut(y), cuda.InOut(status),
            block=(1, 1, 1), grid=(1, 1, 1),
        )
        context.synchronize()
        assert status[0] == 0, status
        np.testing.assert_array_equal(y, expected)
        print(f"DynamicSourceModule child SAXPY passed: {device.name()}, {module.nvcc}, {module.libdir}")
    finally:
        context.pop()
        context.detach()


if __name__ == "__main__":
    main()
