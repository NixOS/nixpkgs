#include <cudss.h>
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

#define CUDA(call) do { \
  cudaError_t status = (call); \
  if (status != cudaSuccess) { \
    std::fprintf(stderr, "%s: %s\n", #call, cudaGetErrorString(status)); \
    std::exit(1); \
  } \
} while (0)
#define CUDSS(call) do { \
  cudssStatus_t status = (call); \
  if (status != CUDSS_STATUS_SUCCESS) { \
    std::fprintf(stderr, "%s: cuDSS status %d\n", #call, int(status)); \
    std::exit(1); \
  } \
} while (0)

template <typename T> T *upload(const std::vector<T> &values) {
  T *device;
  CUDA(cudaMalloc(&device, values.size() * sizeof(T)));
  CUDA(cudaMemcpy(device, values.data(), values.size() * sizeof(T), cudaMemcpyHostToDevice));
  return device;
}

int main() {
  // Nonsymmetric, strictly diagonally dominant tridiagonal CSR matrix.
  // Two independently constructed solutions exercise column-major RHS layout.
  constexpr int n = 64, nrhs = 2;
  std::vector<int> offsets{0}, columns;
  std::vector<double> values, expected(n * nrhs), rhs(n * nrhs, 0), solution(n * nrhs, 0);
  for (int i = 0; i < n; ++i) {
    if (i) { columns.push_back(i - 1); values.push_back(-1); }
    columns.push_back(i); values.push_back(4 + i % 3);
    if (i + 1 < n) { columns.push_back(i + 1); values.push_back(0.5); }
    offsets.push_back(columns.size());
    expected[i] = (i % 9 - 4) * 0.25;
    expected[n + i] = (i % 7 + 1) * (i % 2 ? -0.5 : 0.5);
  }
  for (int k = 0; k < nrhs; ++k)
    for (int i = 0; i < n; ++i)
      for (int p = offsets[i]; p < offsets[i + 1]; ++p)
        rhs[k * n + i] += values[p] * expected[k * n + columns[p]];

  int device = 0, driver = 0, runtime = 0;
  cudaDeviceProp prop;
  CUDA(cudaGetDevice(&device));
  CUDA(cudaGetDeviceProperties(&prop, device));
  CUDA(cudaDriverGetVersion(&driver));
  CUDA(cudaRuntimeGetVersion(&runtime));
  std::printf("device=%s sm=%d%d driver=%d runtime=%d n=%d nnz=%zu nrhs=%d\n",
              prop.name, prop.major, prop.minor, driver, runtime, n, values.size(), nrhs);

  int *dOffsets = upload(offsets), *dColumns = upload(columns);
  double *dValues = upload(values), *dRhs = upload(rhs), *dSolution = upload(solution);
  cudssHandle_t handle;
  cudssConfig_t config;
  cudssData_t data;
  cudssMatrix_t a, x, b;
  CUDSS(cudssCreate(&handle));
  CUDSS(cudssConfigCreate(&config));
  CUDSS(cudssDataCreate(handle, &data));
  CUDSS(cudssMatrixCreateCsr(&a, n, n, values.size(), dOffsets, nullptr, dColumns,
                           dValues, CUDA_R_32I, CUDA_R_64F, CUDSS_MTYPE_GENERAL,
                           CUDSS_MVIEW_FULL, CUDSS_BASE_ZERO));
  CUDSS(cudssMatrixCreateDn(&x, n, nrhs, n, dSolution, CUDA_R_64F, CUDSS_LAYOUT_COL_MAJOR));
  CUDSS(cudssMatrixCreateDn(&b, n, nrhs, n, dRhs, CUDA_R_64F, CUDSS_LAYOUT_COL_MAJOR));
  for (int phase : {CUDSS_PHASE_ANALYSIS, CUDSS_PHASE_FACTORIZATION, CUDSS_PHASE_SOLVE}) {
    CUDSS(cudssExecute(handle, phase, config, data, a, x, b));
    CUDA(cudaDeviceSynchronize());
    int info = -1;
    size_t written = 0;
    CUDSS(cudssDataGet(handle, data, CUDSS_DATA_INFO, &info, sizeof(info), &written));
    std::printf("phase=%d info=%d\n", phase, info);
    if (written != sizeof(info) || info != 0) return 1;
  }
  CUDA(cudaMemcpy(solution.data(), dSolution, solution.size() * sizeof(double), cudaMemcpyDeviceToHost));
  double error = 0, residual = 0, rhsNorm = 0;
  for (int k = 0; k < nrhs; ++k) {
    std::printf("solution[%d]=", k);
    for (int i = 0; i < n; ++i) {
      double xi = solution[k * n + i], ax = 0;
      if (!std::isfinite(xi)) return 1;
      error = std::max(error, std::abs(xi - expected[k * n + i]));
      for (int p = offsets[i]; p < offsets[i + 1]; ++p)
        ax += values[p] * solution[k * n + columns[p]];
      residual = std::max(residual, std::abs(ax - rhs[k * n + i]));
      rhsNorm = std::max(rhsNorm, std::abs(rhs[k * n + i]));
      std::printf("%s%.17g", i ? "," : "", xi);
    }
    std::puts("");
  }
  residual /= rhsNorm;
  std::printf("max_solution_error=%.17g relative_residual=%.17g tolerance=1e-10\n", error, residual);
  CUDSS(cudssMatrixDestroy(a));
  CUDSS(cudssMatrixDestroy(x));
  CUDSS(cudssMatrixDestroy(b));
  CUDSS(cudssDataDestroy(handle, data));
  CUDSS(cudssConfigDestroy(config));
  CUDSS(cudssDestroy(handle));
  CUDA(cudaFree(dOffsets)); CUDA(cudaFree(dColumns)); CUDA(cudaFree(dValues));
  CUDA(cudaFree(dRhs)); CUDA(cudaFree(dSolution));
  return error <= 1e-10 && residual <= 1e-10 ? 0 : 1;
}
