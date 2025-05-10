# Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
{ makeSetupHook, cudaStdenv }:
makeSetupHook {
  name = "setup-cuda-hook";

  substitutions.setupCudaHook = placeholder "out";

  # Point NVCC at a compatible compiler
  substitutions.ccRoot = "${cudaStdenv.cc}";

  # Required in addition to ccRoot as otherwise bin/gcc is looked up
  # when building CMakeCUDACompilerId.cu
  substitutions.ccFullPath = "${cudaStdenv.cc}/bin/${cudaStdenv.cc.targetPrefix}c++";
} ./setup-cuda-hook.sh
