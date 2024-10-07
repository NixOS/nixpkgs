{
  cudaVersion,
  fetchurl,
  final,
  lib,
  package,
  patchelf,
  zlib,
  ...
}:
let
  inherit (lib)
    lists
    maintainers
    meta
    strings
    ;
in
finalAttrs: prevAttrs: {
  src = fetchurl { inherit (package) url hash; };

  # Useful for inspecting why something went wrong.
  brokenConditions =
    let
      cudaTooOld = strings.versionOlder cudaVersion package.minCudaVersion;
      cudaTooNew =
        (package.maxCudaVersion != null) && strings.versionOlder package.maxCudaVersion cudaVersion;
    in
    prevAttrs.brokenConditions
    // {
      "CUDA version is too old" = cudaTooOld;
      "CUDA version is too new" = cudaTooNew;
    };

  buildInputs =
    prevAttrs.buildInputs
    ++ [ zlib ]
    ++ lists.optionals finalAttrs.passthru.useCudatoolkitRunfile [ final.cudatoolkit ]
    ++ lists.optionals (!finalAttrs.passthru.useCudatoolkitRunfile) [ final.libcublas.lib ];

  # Tell autoPatchelf about runtime dependencies. *_infer* libraries only
  # exist in CuDNN 8.
  # NOTE: Versions from CUDNN releases have four components.
  postFixup =
    strings.optionalString
      (
        strings.versionAtLeast finalAttrs.version "8.0.5.0"
        && strings.versionOlder finalAttrs.version "9.0.0.0"
      )
      ''
        ${meta.getExe patchelf} $lib/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
        ${meta.getExe patchelf} $lib/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
      '';

  passthru.useCudatoolkitRunfile = strings.versionOlder cudaVersion "11.3.999";

  meta = prevAttrs.meta // {
    homepage = "https://developer.nvidia.com/cudnn";
    maintainers =
      prevAttrs.meta.maintainers
      ++ (with maintainers; [
        mdaiter
        samuela
        connorbaker
      ]);
    license = {
      shortName = "cuDNN EULA";
      fullName = "NVIDIA cuDNN Software License Agreement (EULA)";
      url = "https://docs.nvidia.com/deeplearning/sdk/cudnn-sla/index.html#supplement";
      free = false;
      redistributable = !finalAttrs.passthru.useCudatoolkitRunfile;
    };
  };
}
