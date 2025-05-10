{
  cudaOlder,
  cudatoolkit,
  cudaMajorMinorVersion,
  fetchurl,
  lib,
  libcublas ? null, # cuDNN uses CUDA Toolkit on old releases, where libcublas is not available.
  patchelf,
  zlib,
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
  src = fetchurl { inherit (finalAttrs.passthru.redistribRelease) hash url; };

  # Useful for inspecting why something went wrong.
  badPlatformsConditions =
    let
      cudaTooOld = cudaOlder finalAttrs.passthru.featureRelease.minCudaVersion;
      cudaTooNew =
        (finalAttrs.passthru.featureRelease.maxCudaVersion != null)
        && strings.versionOlder finalAttrs.passthru.featureRelease.maxCudaVersion cudaMajorMinorVersion;
    in
    prevAttrs.badPlatformsConditions or { }
    // {
      "CUDA version is too old" = cudaTooOld;
      "CUDA version is too new" = cudaTooNew;
    };

  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [ zlib ]
    ++ lists.optionals finalAttrs.passthru.useCudatoolkitRunfile [ cudatoolkit ]
    ++ lists.optionals (!finalAttrs.passthru.useCudatoolkitRunfile) [ (libcublas.lib or null) ];

  # Tell autoPatchelf about runtime dependencies. *_infer* libraries only
  # exist in CuDNN 8.
  # NOTE: Versions from CUDNN releases have four components.
  postFixup =
    prevAttrs.postFixup or ""
    +
      strings.optionalString
        (
          strings.versionAtLeast finalAttrs.version "8.0.5.0"
          && strings.versionOlder finalAttrs.version "9.0.0.0"
        )
        ''
          ${meta.getExe patchelf} $lib/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
          ${meta.getExe patchelf} $lib/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
        '';

  passthru = prevAttrs.passthru or { } // {
    useCudatoolkitRunfile = cudaOlder "11.3.999";
  };

  meta = prevAttrs.meta or { } // {
    homepage = "https://developer.nvidia.com/cudnn";
    maintainers =
      prevAttrs.meta.maintainers or [ ]
      ++ (with maintainers; [
        mdaiter
        samuela
        connorbaker
      ]);
    # TODO(@connorbaker): Temporary workaround to avoid changing the derivation hash since introducing more
    # brokenConditions would change the derivation as they're top-level and __structuredAttrs is set.
    broken =
      prevAttrs.meta.broken or false || (finalAttrs.passthru.useCudatoolkitRunfile && libcublas == null);
    teams = prevAttrs.meta.teams or [ ];
    license = {
      shortName = "cuDNN EULA";
      fullName = "NVIDIA cuDNN Software License Agreement (EULA)";
      url = "https://docs.nvidia.com/deeplearning/sdk/cudnn-sla/index.html#supplement";
      free = false;
      redistributable = !finalAttrs.passthru.useCudatoolkitRunfile;
    };
  };
}
