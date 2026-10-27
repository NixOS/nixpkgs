#include <cuda_runtime_api.h>
#include <nccl.h>

#include <cmath>
#include <cstdio>

namespace {

bool CheckCuda(cudaError_t result, const char* operation) {
  if (result == cudaSuccess) return true;
  std::fprintf(stderr, "%s: %s\n", operation, cudaGetErrorString(result));
  return false;
}

bool CheckNccl(ncclResult_t result, const char* operation) {
  if (result == ncclSuccess) return true;
  std::fprintf(stderr, "%s: %s\n", operation, ncclGetErrorString(result));
  return false;
}

bool Cleanup(ncclComm_t communicator, float* device_output,
             float* device_input, bool abort_communicator) {
  bool success = true;
  if (communicator != nullptr) {
    const ncclResult_t result = abort_communicator
                                    ? ncclCommAbort(communicator)
                                    : ncclCommDestroy(communicator);
    if (!CheckNccl(result, abort_communicator ? "ncclCommAbort"
                                              : "ncclCommDestroy")) {
      success = false;
    }
  }
  if (device_output != nullptr &&
      !CheckCuda(cudaFree(device_output), "cudaFree output")) {
    success = false;
  }
  if (device_input != nullptr &&
      !CheckCuda(cudaFree(device_input), "cudaFree input")) {
    success = false;
  }
  return success;
}

}  // namespace

int main() {
  int device_count = 0;
  if (!CheckCuda(cudaGetDeviceCount(&device_count), "cudaGetDeviceCount")) {
    return 1;
  }
  if (device_count < 1) {
    std::fputs("no CUDA device available\n", stderr);
    return 1;
  }
  if (!CheckCuda(cudaSetDevice(0), "cudaSetDevice")) return 1;

  int runtime_version = 0;
  if (!CheckNccl(ncclGetVersion(&runtime_version), "ncclGetVersion")) {
    return 1;
  }
  if (runtime_version != NCCL_VERSION_CODE) {
    std::fprintf(stderr, "NCCL header/runtime version mismatch: %d != %d\n",
                 NCCL_VERSION_CODE, runtime_version);
    return 1;
  }

  constexpr float input = 7.0f;
  float output = 0.0f;
  float* device_input = nullptr;
  float* device_output = nullptr;
  ncclComm_t communicator = nullptr;
  ncclUniqueId id;

  if (!CheckCuda(cudaMalloc(&device_input, sizeof(input)), "cudaMalloc input") ||
      !CheckCuda(cudaMalloc(&device_output, sizeof(output)),
                 "cudaMalloc output") ||
      !CheckCuda(cudaMemcpy(device_input, &input, sizeof(input),
                            cudaMemcpyHostToDevice),
                 "cudaMemcpy input") ||
      !CheckNccl(ncclGetUniqueId(&id), "ncclGetUniqueId") ||
      !CheckNccl(ncclCommInitRank(&communicator, 1, id, 0),
                 "ncclCommInitRank") ||
      !CheckNccl(ncclAllReduce(device_input, device_output, 1, ncclFloat,
                               ncclSum, communicator, nullptr),
                 "ncclAllReduce") ||
      !CheckCuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize") ||
      !CheckCuda(cudaMemcpy(&output, device_output, sizeof(output),
                            cudaMemcpyDeviceToHost),
                 "cudaMemcpy output")) {
    Cleanup(communicator, device_output, device_input, true);
    return 1;
  }

  const bool result_ok = std::fabs(output - input) < 1e-6f;
  const bool cleanup_ok =
      Cleanup(communicator, device_output, device_input, false);
  if (!result_ok) {
    std::fprintf(stderr, "unexpected one-rank all-reduce result: %.9g\n", output);
  }
  if (!cleanup_ok || !result_ok) return 1;

  std::printf("PASS NCCL %d one-rank all-reduce: %.9g\n", runtime_version,
              output);
  return 0;
}
