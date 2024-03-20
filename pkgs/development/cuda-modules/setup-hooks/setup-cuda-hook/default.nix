# Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
{ backendStdenv, makeSetupHook }:
makeSetupHook
  {
    name = "setup-cuda-hook";

    substitutions = {
      # Required in addition to ccRoot as otherwise bin/gcc is looked up
      # when building CMakeCUDACompilerId.cu
      ccFullPath = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
      # Point NVCC at a compatible compiler
      ccRoot = "${backendStdenv.cc}";
      setupCudaHook = placeholder "out";
    };
  }
  ./setup-cuda-hook.sh
