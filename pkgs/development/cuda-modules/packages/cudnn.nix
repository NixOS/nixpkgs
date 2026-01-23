{
  _cuda,
  backendStdenv,
  buildRedist,
  lib,
  libcublas,
  patchelf,
  zlib,
}:
buildRedist (
  finalAttrs:
  let
    inherit (backendStdenv) cudaCapabilities;
    cudnnAtLeast = lib.versionAtLeast finalAttrs.version;
    cudnnOlder = lib.versionOlder finalAttrs.version;
  in
  {
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
    postFixup = lib.optionalString (cudnnAtLeast "8" && cudnnOlder "9") ''
      ${lib.getExe patchelf} ''${!outputLib:?}/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
      ${lib.getExe patchelf} ''${!outputLib:?}/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
    '';

    # NOTE:
    #   With cuDNN forward compatiblity, all non-natively supported compute capabilities JIT compile PTX kernels.
    #
    #   While this is sub-optimal and we should warn the user and encourage them to use a newer version of cuDNN, we
    #   have no clean mechanism by which we can warn the user, or allow silencing such a warning if the use of an
    #   older cuDNN is intentional.
    #
    #   As such, we only warn about capabilities which are no longer supported by cuDNN.
    #
    # NOTE:
    #
    #   NVIDIA promises forward compatibility of cuDNN for major versions of CUDA. As an example, the cuDNN build for
    #   CUDA 12 is compatible with all, and will remain compatible with, all CUDA 12 releases. However, this does not
    #   extend to static linking with CUDA 11!
    #
    #   We don't need to check the CUDA version to see if it falls within some supported range -- if a user decides
    #   to do static linking against some odd combination of CUDA 11 and cuDNN, that's on them.
    #
    platformAssertions =
      let
        # Create variables and use logical OR to allow short-circuiting.

        cudnnAtLeast912 = cudnnAtLeast "9.12";
        cudnnAtLeast88 = cudnnAtLeast912 || cudnnAtLeast "8.8";
        cudnnAtLeast85 = cudnnAtLeast88 || cudnnAtLeast "8.5";

        allCCNewerThan75 = lib.all (lib.flip lib.versionAtLeast "7.5") cudaCapabilities;
        allCCNewerThan50 = allCCNewerThan75 || lib.all (lib.flip lib.versionAtLeast "5.0") cudaCapabilities;
        allCCNewerThan35 = allCCNewerThan50 || lib.all (lib.flip lib.versionAtLeast "3.5") cudaCapabilities;
      in
      [
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-850/support-matrix/index.html#cudnn-cuda-hardware-versions
        {
          message =
            "cuDNN releases since 8.5 (found ${finalAttrs.version})"
            + " support CUDA compute capabilities 3.5 and newer (found ${builtins.toJSON cudaCapabilities})";
          assertion = cudnnAtLeast85 -> allCCNewerThan35;
        }
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-880/support-matrix/index.html#cudnn-cuda-hardware-versions
        {
          message =
            "cuDNN releases since 8.8 (found ${finalAttrs.version})"
            + " support CUDA compute capabilities 5.0 and newer (found ${builtins.toJSON cudaCapabilities})";
          assertion = cudnnAtLeast88 -> allCCNewerThan50;
        }
        # https://docs.nvidia.com/deeplearning/cudnn/backend/v9.12.0/reference/support-matrix.html#gpu-cuda-toolkit-and-cuda-driver-requirements
        {
          message =
            "cuDNN releases since 9.12 (found ${finalAttrs.version})"
            + " support CUDA compute capabilities 7.5 and newer (found ${builtins.toJSON cudaCapabilities})";
          assertion = cudnnAtLeast912 -> allCCNewerThan75;
        }
      ];

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
  }
)
