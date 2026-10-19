{
  backendStdenv,
  buildRedist,
  cuda_nvrtc,
  cudnn-frontend,
  lib,
  runCommand,
  zlib,
}:
buildRedist (finalAttrs: {
  redistName = "cudnn";
  pname = "cudnn_jit";

  # cuDNN JIT ships only dynamic libraries.
  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [ zlib ];

  # From 9.27.0, libcudnn_engines_runtime_compiled links directly against the driver library, which is provided at
  # runtime.
  autoPatchelfIgnoreMissingDeps = lib.optionals (lib.versionAtLeast finalAttrs.version "9.27") [
    "libcuda.so.1"
  ];

  # libcudnn_graph dlopens NVRTC to compile the runtime fusion engines.
  appendRunpaths = [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%d
  ];

  platformAssertions = [
    {
      message =
        "cuDNN JIT (found ${finalAttrs.version})"
        + " supports CUDA compute capabilities 8.0 and newer (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion = lib.all (lib.flip lib.versionAtLeast "8.0") backendStdenv.cudaCapabilities;
    }
  ];

  # Runs the cuDNN frontend samples JIT supports, excluding those relying on precompiled engines.
  passthru.gpuCheck =
    runCommand "${finalAttrs.finalPackage.name}-gpu-check"
      {
        __structuredAttrs = true;
        strictDeps = true;
        nativeBuildInputs = [
          (cudnn-frontend.override {
            cudnn = finalAttrs.finalPackage;
            withTests = false;
          }).samples
        ];
        requiredSystemFeatures = [ "cuda" ];
        meta = {
          inherit (finalAttrs.finalPackage.meta) badPlatforms platforms teams;
        };
      }
      ''
        samples \
          --rng-seed=0 \
          '[sdpa],[layernorm],[rmsnorm],[pointwise],[reduction],[matmul]' \
          '~Complex FP32 Matmul' \
          '~Matmul custom plan'
        touch "$out"
      '';

  meta = {
    description = "cuDNN configuration providing only the runtime fusion engines, as a smaller substitute for cudnn";
    longDescription = ''
      cuDNN JIT supports only the runtime fusion engines through the graph API. It substitutes for cudnn: the libraries
      share sonames and headers, and cuDNN selects the JIT configuration when only the JIT libraries are present.
    '';
    homepage = "https://docs.nvidia.com/deeplearning/cudnn/latest/developer/graph-api.html#cudnn-jit";
    changelog = "https://docs.nvidia.com/deeplearning/cudnn/backend/latest/release-notes.html";
    license = lib.licenses.nvidiaCudnn;
  };
})
