// Compresses and decompresses a batch of chunks with nvCOMP's batched LZ4 C API and checks the result.
#include <cuda_runtime.h>
#include <nvcomp/lz4.h>
#include <nvcomp/version.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

#define CHECK_CUDA(call)                                                                       \
  do {                                                                                         \
    cudaError_t err = (call);                                                                  \
    if (err != cudaSuccess) {                                                                  \
      std::fprintf(stderr, "%s:%d: %s\n", __FILE__, __LINE__, cudaGetErrorString(err));        \
      std::exit(1);                                                                            \
    }                                                                                          \
  } while (0)

#define CHECK_NVCOMP(call)                                                                     \
  do {                                                                                         \
    nvcompStatus_t status = (call);                                                            \
    if (status != nvcompSuccess) {                                                             \
      std::fprintf(stderr, "%s:%d: nvCOMP error %d\n", __FILE__, __LINE__, (int)status);       \
      std::exit(1);                                                                            \
    }                                                                                          \
  } while (0)

template <typename T> T *deviceCopy(const std::vector<T> &host) {
  T *device;
  CHECK_CUDA(cudaMalloc(&device, host.size() * sizeof(T)));
  CHECK_CUDA(cudaMemcpy(device, host.data(), host.size() * sizeof(T), cudaMemcpyHostToDevice));
  return device;
}

template <typename T> std::vector<T> hostCopy(const T *device, size_t count) {
  std::vector<T> host(count);
  CHECK_CUDA(cudaMemcpy(host.data(), device, count * sizeof(T), cudaMemcpyDeviceToHost));
  return host;
}

int main() {
  const size_t chunkBytes = 65536, numChunks = 8, totalBytes = chunkBytes * numChunks;
  std::printf("nvCOMP %d.%d.%d\n", NVCOMP_VER_MAJOR, NVCOMP_VER_MINOR, NVCOMP_VER_PATCH);

  std::vector<unsigned char> input(totalBytes);
  for (size_t i = 0; i < totalBytes; i++)
    input[i] = (unsigned char)((i / 7) % 61); // compressible

  cudaStream_t stream;
  CHECK_CUDA(cudaStreamCreate(&stream));

  size_t maxCompressedChunkBytes;
  CHECK_NVCOMP(nvcompBatchedLZ4CompressGetMaxOutputChunkSize(chunkBytes, nvcompBatchedLZ4CompressDefaultOpts,
                                                             &maxCompressedChunkBytes));

  unsigned char *input_d = deviceCopy(input), *compressed_d, *decompressed_d;
  CHECK_CUDA(cudaMalloc(&compressed_d, maxCompressedChunkBytes * numChunks));
  CHECK_CUDA(cudaMalloc(&decompressed_d, totalBytes));

  std::vector<void *> inputPtrs(numChunks), compressedPtrs(numChunks), decompressedPtrs(numChunks);
  for (size_t i = 0; i < numChunks; i++) {
    inputPtrs[i] = input_d + i * chunkBytes;
    compressedPtrs[i] = compressed_d + i * maxCompressedChunkBytes;
    decompressedPtrs[i] = decompressed_d + i * chunkBytes;
  }
  void **inputPtrs_d = deviceCopy(inputPtrs), **compressedPtrs_d = deviceCopy(compressedPtrs),
       **decompressedPtrs_d = deviceCopy(decompressedPtrs);
  size_t *chunkBytes_d = deviceCopy(std::vector<size_t>(numChunks, chunkBytes)), *compressedBytes_d,
         *decompressedBytes_d;
  nvcompStatus_t *statuses_d;
  CHECK_CUDA(cudaMalloc(&compressedBytes_d, numChunks * sizeof(size_t)));
  CHECK_CUDA(cudaMalloc(&decompressedBytes_d, numChunks * sizeof(size_t)));
  CHECK_CUDA(cudaMalloc(&statuses_d, numChunks * sizeof(nvcompStatus_t)));

  size_t compressTempBytes, decompressTempBytes;
  CHECK_NVCOMP(nvcompBatchedLZ4CompressGetTempSize(numChunks, chunkBytes, nvcompBatchedLZ4CompressDefaultOpts,
                                                   &compressTempBytes, totalBytes, stream));
  CHECK_NVCOMP(nvcompBatchedLZ4DecompressGetTempSize(numChunks, chunkBytes, nvcompBatchedLZ4DecompressDefaultOpts,
                                                     &decompressTempBytes, totalBytes, stream));
  void *temp_d;
  CHECK_CUDA(cudaMalloc(&temp_d, compressTempBytes > decompressTempBytes ? compressTempBytes : decompressTempBytes));

  CHECK_NVCOMP(nvcompBatchedLZ4CompressAsync(inputPtrs_d, chunkBytes_d, chunkBytes, numChunks, temp_d,
                                             compressTempBytes, compressedPtrs_d, compressedBytes_d,
                                             nvcompBatchedLZ4CompressDefaultOpts, statuses_d, stream));
  CHECK_NVCOMP(nvcompBatchedLZ4DecompressAsync(compressedPtrs_d, compressedBytes_d, chunkBytes_d,
                                               decompressedBytes_d, numChunks, temp_d, decompressTempBytes,
                                               decompressedPtrs_d, nvcompBatchedLZ4DecompressDefaultOpts,
                                               statuses_d, stream));
  CHECK_CUDA(cudaStreamSynchronize(stream));

  std::vector<size_t> compressedBytes = hostCopy(compressedBytes_d, numChunks),
                      decompressedBytes = hostCopy(decompressedBytes_d, numChunks);
  std::vector<nvcompStatus_t> statuses = hostCopy(statuses_d, numChunks);
  std::vector<unsigned char> output = hostCopy(decompressed_d, totalBytes);

  size_t totalCompressedBytes = 0;
  for (size_t i = 0; i < numChunks; i++) {
    totalCompressedBytes += compressedBytes[i];
    if (statuses[i] != nvcompSuccess || decompressedBytes[i] != chunkBytes) {
      std::fprintf(stderr, "chunk %zu: status %d, %zu bytes\n", i, (int)statuses[i], decompressedBytes[i]);
      return 1;
    }
  }
  if (std::memcmp(input.data(), output.data(), totalBytes) != 0) {
    std::fprintf(stderr, "decompressed data differs from the input\n");
    return 1;
  }
  std::printf("LZ4 round trip: %zu -> %zu bytes\n", totalBytes, totalCompressedBytes);
  return 0;
}
