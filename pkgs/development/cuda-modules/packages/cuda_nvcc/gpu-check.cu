// Launches a kernel from another kernel, which nvlink links with libcudadevrt, and prints the result.

#include <cstdio>

#define CHECK(call)                                                                                                    \
    do {                                                                                                               \
        cudaError_t error = (call);                                                                                    \
        if (error != cudaSuccess) {                                                                                    \
            std::fprintf(stderr, "%s: %s\n", #call, cudaGetErrorString(error));                                       \
            return 1;                                                                                                  \
        }                                                                                                              \
    } while (0)

__global__ void child(int *p) { *p = 42; }

__global__ void parent(int *p) { child<<<1, 1>>>(p); }

int main() {
    int *device = nullptr;
    int host = 0;
    CHECK(cudaMalloc(&device, sizeof(int)));
    parent<<<1, 1>>>(device);
    CHECK(cudaGetLastError());
    CHECK(cudaDeviceSynchronize());
    CHECK(cudaMemcpy(&host, device, sizeof(int), cudaMemcpyDeviceToHost));
    std::printf("%d\n", host);
    return 0;
}
