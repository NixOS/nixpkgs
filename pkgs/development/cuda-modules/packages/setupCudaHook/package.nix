# Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
{ makeSetupHook, backendStdenv }:
makeSetupHook {
  name = "setup-cuda-hook";

  substitutions.setupCudaHook = placeholder "out";

  # Point NVCC at a compatible compiler
  substitutions.ccRoot = "${backendStdenv.cc}";

  # Required in addition to ccRoot as otherwise bin/gcc is looked up
  # when building CMakeCUDACompilerId.cu
  substitutions.ccFullPath = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
} ./setup-cuda-hook.sh
