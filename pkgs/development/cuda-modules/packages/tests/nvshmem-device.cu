#include <cuda_runtime.h>
#include <nvshmem.h>
#include <nvshmemx.h>

#include <array>
#include <cstdio>
#include <cstdlib>

constexpr int elements = 257;
constexpr int threads = 128;
constexpr int words = 2 * elements + threads + 3;

static void cuda_check(cudaError_t status, const char *operation) {
    if (status != cudaSuccess) {
        std::fprintf(stderr, "%s: %s\n", operation, cudaGetErrorString(status));
        std::exit(1);
    }
}

static void shmem_check(int status, const char *operation) {
    if (status != 0) {
        std::fprintf(stderr, "%s: NVSHMEM status %d\n", operation, status);
        std::exit(1);
    }
}

// One collective block is sufficient for this single-PE test. The barriers
// deliberately execute on one thread, after every issuing thread has quieted.
__global__ void exercise(int *storage) {
    int *payload = storage;
    int *observed = payload + elements;
    int *tickets = observed + elements;
    int *counter = tickets + threads;
    const int pe = nvshmem_my_pe();
    for (int i = threadIdx.x; i < elements; i += blockDim.x)
        nvshmem_int_p(payload + i, 7 * i - 19, pe);
    nvshmem_quiet();
    __syncthreads();
    if (threadIdx.x == 0) nvshmem_barrier_all();
    __syncthreads();

    for (int i = threadIdx.x; i < elements; i += blockDim.x)
        observed[i] = nvshmem_int_g(payload + i, pe);
    tickets[threadIdx.x] = nvshmem_int_atomic_fetch_add(counter, 1, pe);
    nvshmem_quiet();
    __syncthreads();
    if (threadIdx.x == 0) {
        nvshmem_barrier_all();
        counter[1] = pe;
        counter[2] = nvshmem_n_pes();
    }
}

int main() {
    cuda_check(cudaSetDevice(0), "cudaSetDevice");
    cudaDeviceProp device{};
    cuda_check(cudaGetDeviceProperties(&device, 0), "cudaGetDeviceProperties");
    nvshmemx_uniqueid_t id = NVSHMEMX_UNIQUEID_INITIALIZER;
    nvshmemx_init_attr_t attributes = NVSHMEMX_INIT_ATTR_INITIALIZER;
    shmem_check(nvshmemx_get_uniqueid(&id), "nvshmemx_get_uniqueid");
    shmem_check(nvshmemx_set_attr_uniqueid_args(0, 1, &id, &attributes),
                "nvshmemx_set_attr_uniqueid_args");
    shmem_check(nvshmemx_init_attr(NVSHMEMX_INIT_WITH_UNIQUEID, &attributes),
                "nvshmemx_init_attr");
    if (nvshmem_my_pe() != 0 || nvshmem_n_pes() != 1) return 2;

    int *storage = static_cast<int *>(nvshmem_malloc(words * sizeof(int)));
    if (storage == nullptr) return 3;
    cuda_check(cudaMemset(storage, 0xff, words * sizeof(int)), "initialize sentinels");
    cuda_check(cudaMemset(storage + 2 * elements + threads, 0, sizeof(int)),
               "initialize atomic counter");
    void *arguments[] = {&storage};
    shmem_check(nvshmemx_collective_launch(reinterpret_cast<const void *>(exercise),
                                          dim3(1), dim3(threads), arguments, 0, nullptr),
                "nvshmemx_collective_launch");
    cuda_check(cudaGetLastError(), "kernel launch");
    cuda_check(cudaDeviceSynchronize(), "kernel execution");
    std::array<int, words> result{};
    cuda_check(cudaMemcpy(result.data(), storage, sizeof(result), cudaMemcpyDeviceToHost),
               "read device results");
    nvshmem_free(storage);
    nvshmem_finalize();

    for (int i = 0; i < elements; ++i) {
        if (result[i] != 7 * i - 19 || result[elements + i] != 7 * i - 19) {
            std::fprintf(stderr, "put/get mismatch at %d: %d, %d\n", i,
                         result[i], result[elements + i]);
            return 4;
        }
    }
    std::array<bool, threads> seen{};
    for (int i = 0; i < threads; ++i) {
        const int ticket = result[2 * elements + i];
        if (ticket < 0 || ticket >= threads || seen[ticket]) {
            std::fprintf(stderr, "invalid atomic ticket at %d: %d\n", i, ticket);
            return 5;
        }
        seen[ticket] = true;
    }
    if (result[words - 3] != threads || result[words - 2] != 0 || result[words - 1] != 1)
        return 6;
    std::printf("{\"passed\":true,\"gpu\":\"%s\",\"compute\":\"%d.%d\","
                "\"pes\":1,\"put_get_values\":%d,\"atomic_tickets\":%d}\n",
                device.name, device.major, device.minor, elements, threads);
    return 0;
}
