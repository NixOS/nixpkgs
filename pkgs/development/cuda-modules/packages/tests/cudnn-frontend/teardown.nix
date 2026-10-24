{
  backendStdenv,
  cuda_cudart,
  cudaNamePrefix,
  cudnn,
  cudnn-frontend,
  lib,
}:
# A static constructed before get_cuda_symbol()'s statics is destroyed after them, as
# TransformerEngine's fused-attention graph cache is. Its destructor must still be able to resolve
# CUDA symbols: https://github.com/NVIDIA/cudnn-frontend/issues/1486
backendStdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${cudaNamePrefix}-tests-cudnn-frontend-teardown";

  dontUnpack = true;

  buildInputs = [
    cuda_cudart
    cudnn
    cudnn-frontend
  ];

  buildPhase = ''
    runHook preBuild

    cat > main.cpp <<'CPP'
    #include <cstring>
    #include <unordered_map>
    #include <cuda_runtime.h>
    #include <cudnn.h>
    #define NV_CUDNN_FRONTEND_USE_DYNAMIC_LOADING
    #include <cudnn_frontend_shim.h>

    namespace cudnn_frontend {
    void *cudnn_dlhandle = nullptr;
    }

    using cudnn_frontend::detail::CudaLibrary;
    using cudnn_frontend::detail::get_cuda_symbol;

    struct ReleasesAtExit {
      ~ReleasesAtExit() { get_cuda_symbol(CudaLibrary::CUDART, "cudaGetDeviceCount"); }
    } releasesAtExit;

    int main() { return get_cuda_symbol(CudaLibrary::CUDART, "cudaGetDeviceCount") == nullptr; }
    CPP

    $CXX -std=c++17 -g -fsanitize=address main.cpp -ldl -o teardown

    runHook postBuild
  '';

  # Resolving a symbol only loads libcudart, so no GPU is needed.
  doCheck = backendStdenv.buildPlatform.canExecute backendStdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    # The fix leaks the handle map on purpose, so leak detection is off.
    CUDNN_FRONTEND_CUDART_LIB_NAME=${lib.getLib cuda_cudart}/lib/libcudart.so \
      ASAN_OPTIONS=detect_leaks=0 \
      ./teardown

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    touch "$out"
    runHook postInstall
  '';
}
