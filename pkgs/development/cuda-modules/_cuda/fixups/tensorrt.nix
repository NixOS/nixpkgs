{
  _cuda,
  cudaOlder,
  cudaPackages,
  cudaMajorMinorVersion,
  lib,
  patchelf,
  requireFile,
  stdenv,
}:
let
  inherit (lib)
    attrsets
    maintainers
    meta
    strings
    versions
    ;
  inherit (stdenv) hostPlatform;
  # targetArch :: String
  targetArch = attrsets.attrByPath [ hostPlatform.system ] "unsupported" {
    x86_64-linux = "x86_64-linux-gnu";
    aarch64-linux = "aarch64-linux-gnu";
  };
in
finalAttrs: prevAttrs: {
  # Useful for inspecting why something went wrong.
  brokenConditions =
    let
      cudaTooOld = cudaOlder finalAttrs.passthru.featureRelease.minCudaVersion;
      cudaTooNew =
        (finalAttrs.passthru.featureRelease.maxCudaVersion != null)
        && strings.versionOlder finalAttrs.passthru.featureRelease.maxCudaVersion cudaMajorMinorVersion;
      cudnnVersionIsSpecified = finalAttrs.passthru.featureRelease.cudnnVersion != null;
      cudnnVersionSpecified = versions.majorMinor finalAttrs.passthru.featureRelease.cudnnVersion;
      cudnnVersionProvided = versions.majorMinor finalAttrs.passthru.cudnn.version;
      cudnnTooOld =
        cudnnVersionIsSpecified && (strings.versionOlder cudnnVersionProvided cudnnVersionSpecified);
      cudnnTooNew =
        cudnnVersionIsSpecified && (strings.versionOlder cudnnVersionSpecified cudnnVersionProvided);
    in
    prevAttrs.brokenConditions or { }
    // {
      "CUDA version is too old" = cudaTooOld;
      "CUDA version is too new" = cudaTooNew;
      "CUDNN version is too old" = cudnnTooOld;
      "CUDNN version is too new" = cudnnTooNew;
    };

  src = requireFile {
    name = finalAttrs.passthru.redistribRelease.filename;
    inherit (finalAttrs.passthru.redistribRelease) hash;
    message = ''
      To use the TensorRT derivation, you must join the NVIDIA Developer Program and
      download the ${finalAttrs.version} TAR package for CUDA ${cudaMajorMinorVersion} from
      ${finalAttrs.meta.homepage}.

      Once you have downloaded the file, add it to the store with the following
      command, and try building this derivation again.

      $ nix-store --add-fixed sha256 ${finalAttrs.passthru.redistribRelease.filename}
    '';
  };

  # We need to look inside the extracted output to get the files we need.
  sourceRoot = "TensorRT-${finalAttrs.version}";

  buildInputs = prevAttrs.buildInputs or [ ] ++ [ (finalAttrs.passthru.cudnn.lib or null) ];

  preInstall =
    prevAttrs.preInstall or ""
    + strings.optionalString (targetArch != "unsupported") ''
      # Replace symlinks to bin and lib with the actual directories from targets.
      for dir in bin lib; do
        rm "$dir"
        mv "targets/${targetArch}/$dir" "$dir"
      done

      # Remove broken symlinks
      for dir in include samples; do
        rm "targets/${targetArch}/$dir" || :
      done
    '';

  # Tell autoPatchelf about runtime dependencies.
  postFixup =
    let
      versionTriple = "${versions.majorMinor finalAttrs.version}.${versions.patch finalAttrs.version}";
    in
    prevAttrs.postFixup or ""
    + ''
      ${meta.getExe' patchelf "patchelf"} --add-needed libnvinfer.so \
        "$lib/lib/libnvinfer.so.${versionTriple}" \
        "$lib/lib/libnvinfer_plugin.so.${versionTriple}" \
        "$lib/lib/libnvinfer_builder_resource.so.${versionTriple}"
    '';

  passthru = prevAttrs.passthru or { } // {
    # The CUDNN used with TensorRT.
    # If null, the default cudnn derivation will be used.
    # If a version is specified, the cudnn derivation with that version will be used,
    # unless it is not available, in which case the default cudnn derivation will be used.
    cudnn =
      let
        desiredName = _cuda.lib.mkVersionedName "cudnn" (
          lib.versions.majorMinor finalAttrs.passthru.featureRelease.cudnnVersion
        );
      in
      if finalAttrs.passthru.featureRelease.cudnnVersion == null || (cudaPackages ? desiredName) then
        cudaPackages.cudnn
      else
        cudaPackages.${desiredName};
  };

  meta = prevAttrs.meta or { } // {
    badPlatforms =
      prevAttrs.meta.badPlatforms or [ ]
      ++ lib.optionals (targetArch == "unsupported") [ hostPlatform.system ];
    homepage = "https://developer.nvidia.com/tensorrt";
    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ maintainers.aidalgol ];
    teams = prevAttrs.meta.teams or [ ];

    # Building TensorRT on Hydra is impossible because of the non-redistributable
    # license and because the source needs to be manually downloaded from the
    # NVIDIA Developer Program (see requireFile above).
    hydraPlatforms = lib.platforms.none;
  };
}
