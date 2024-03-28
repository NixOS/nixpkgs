# Currently propagated by cuda_nvcc or cudatoolkit, rather than used directly
{ backendStdenv, makeSetupHook }:
let
  inherit (backendStdenv) cc;
in
makeSetupHook
  {
    name = "setup-cuda-hook";
    substitutions = {
      # Required in addition to ccRoot as otherwise bin/gcc is looked up
      # when building CMakeCUDACompilerId.cu
      ccFullPath = "${cc}/bin/${cc.targetPrefix}c++";
      # Point NVCC at a compatible compiler
      ccRoot = "${cc}";
      setupCudaHook = placeholder "out";
    };
  }
  ./setup-cuda-hook.sh
