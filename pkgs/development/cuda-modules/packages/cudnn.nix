{
  _cuda,
  buildRedist,
  lib,
  libcublas,
  patchelf,
  zlib,
}:
buildRedist (finalAttrs: {
  redistName = "cudnn";
  pname = "cudnn";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  buildInputs = [
    # NOTE: Verions of CUDNN after 9.0 no longer depend on libcublas:
    # https://docs.nvidia.com/deeplearning/cudnn/latest/release-notes.html?highlight=cublas#cudnn-9-0-0
    # However, NVIDIA only provides libcublasLT via the libcublas package.
    (lib.getLib libcublas)
    zlib
  ];

  # Tell autoPatchelf about runtime dependencies. *_infer* libraries only
  # exist in CuDNN 8.
  # NOTE: Versions from CUDNN releases have four components.
  postFixup =
    lib.optionalString
      (lib.versionAtLeast finalAttrs.version "8.0.5.0" && lib.versionOlder finalAttrs.version "9.0.0.0")
      ''
        ${lib.getExe patchelf} $lib/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
        ${lib.getExe patchelf} $lib/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
      '';

  # TODO(@connorbaker): Broken conditions for cuDNN used out of scope.
  # platformAssertions =
  #   let
  #     cudaTooOld = cudaOlder finalAttrs.passthru.featureRelease.minCudaVersion;
  #     cudaTooNew =
  #       (finalAttrs.passthru.featureRelease.maxCudaVersion != null)
  #       && lib.versionOlder finalAttrs.passthru.featureRelease.maxCudaVersion cudaMajorMinorVersion;
  #   in
  #   prevAttrs.passthru.platformAssertions or [ ]
  #   ++ [
  #     {
  #       message = "CUDA version is too old";
  #       assertion = cudaTooOld;
  #     }
  #     {
  #       message = "CUDA version is too new";
  #       assertion = cudaTooNew;
  #     }
  #   ];

  meta = {
    description = "GPU-accelerated library of primitives for deep neural networks";
    longDescription = ''
      The NVIDIA CUDA Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural
      networks.
    '';
    homepage = "https://developer.nvidia.com/cudnn";
    changelog = "https://docs.nvidia.com/deeplearning/cudnn/backend/latest/release-notes.html";

    license = _cuda.lib.licenses.cudnn;

    maintainers = with lib.maintainers; [
      mdaiter
      samuela
      connorbaker
    ];
  };
})
