#include <cuda_runtime.h>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <type_traits>

// Host-library promotion remains part of the interface even when NVCC
// annotates overloads imported into the global CUDA math namespace.
static_assert(std::is_same<decltype(std::pow(1.0f, 2)), double>::value);
static_assert(std::is_same<decltype(std::pow(1.0f, 2.0f)), float>::value);
static_assert(std::is_same<decltype(std::pow(1.0L, 2)), long double>::value);

template <class T> __host__ __device__ int classify(T x) {
  return (::isfinite(x) ? 1 : 0) | (::isinf(x) ? 2 : 0) |
         (::isnan(x) ? 4 : 0) | (::signbit(x) ? 8 : 0);
}

__global__ void mathKernel(double *values, int *classes, float x, double y, int integer) {
  values[0] = ::pow(x, integer);
  values[1] = ::pow(2, static_cast<float>(y));
  values[2] = ::pow(x, y);
  values[3] = ::pow(static_cast<double>(x), static_cast<float>(y));
  values[4] = ::sin(0.0f) + ::cos(0.0) + ::sqrt(4.0f);
  values[5] = ::abs(-static_cast<long>(integer));
  values[6] = ::abs(-static_cast<long long>(integer) - 1);
  const float inputs[] = {0.0f, -0.0f, 1.0f, -1.0f, INFINITY, -INFINITY, NAN};
  for (int i = 0; i < 7; ++i) {
    classes[i] = classify(inputs[i]);
    classes[i + 7] = classify(static_cast<double>(inputs[i]));
  }
}

bool check(cudaError_t status) {
  if (status == cudaSuccess) return true;
  std::fprintf(stderr, "CUDA: %s\n", cudaGetErrorString(status));
  return false;
}

int main(int argc, char **argv) {
  const float inputs[] = {0.0f, -0.0f, 1.0f, -1.0f, INFINITY, -INFINITY, NAN};
  const int expectedClasses[] = {1, 9, 1, 9, 2, 10, 4};
  for (int i = 0; i < 7; ++i) {
    if (classify(inputs[i]) != expectedClasses[i] ||
        classify(static_cast<double>(inputs[i])) != expectedClasses[i] ||
        classify(static_cast<long double>(inputs[i])) != expectedClasses[i]) return 1;
  }
  if (std::pow(2.0f, 3) != 8.0 || std::pow(2, 3.0f) != 8.0 ||
      std::pow(2.0L, 3) != 8.0L) return 1;
  if (argc == 2 && std::strcmp(argv[1], "--host-only") == 0) return 0;

  double *values;
  int *classes;
  if (!check(cudaMallocManaged(&values, 7 * sizeof(double))) ||
      !check(cudaMallocManaged(&classes, 14 * sizeof(int)))) return 1;
  // Successful compilation and launch did not expose missing device overload
  // annotations: affected NVCC kernels silently left all outputs untouched.
  for (int i = 0; i < 7; ++i) values[i] = -999.0;
  for (int i = 0; i < 14; ++i) classes[i] = -999;
  mathKernel<<<1, 1>>>(values, classes, 2.0f, 3.0, 3);
  if (!check(cudaGetLastError()) || !check(cudaDeviceSynchronize())) return 1;
  const double expectedValues[] = {8, 8, 8, 8, 3, 3, 4};
  for (int i = 0; i < 7; ++i) {
    if (values[i] != expectedValues[i]) {
      std::fprintf(stderr, "math[%d]: got %g, expected %g\n", i, values[i], expectedValues[i]);
      return 1;
    }
  }
  for (int i = 0; i < 14; ++i) {
    if (classes[i] != expectedClasses[i % 7]) {
      std::fprintf(stderr, "classification[%d]: got %d\n", i, classes[i]);
      return 1;
    }
  }
  return check(cudaFree(values)) && check(cudaFree(classes)) ? 0 : 1;
}
