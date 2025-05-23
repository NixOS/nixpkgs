{
  _cuda,
  cudaAtLeast,
  cudaOlder,
  cudaPackages,
  cudaMajorMinorVersion,
  lib,
  patchelf,
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
finalAttrs: prevAttrs:
let
  constraints = _cuda.db.archive.sha256.${finalAttrs.src.hash or ""}.extraConstraints or { };
in
{
  # Useful for inspecting why something went wrong.
  brokenConditions =
    let
      cudaTooOld = constraints ? cuda.">=" && !(cudaAtLeast constraints.cuda.">=");
      cudaTooNew = constraints ? cuda."<" && !(cudaOlder constraints.cuda."<");
      cudnnVersionIsSpecified = constraints.cudnn.">=" or null != null;
      cudnnVersionSpecified = versions.majorMinor constraints.cudnn.">=" or null;
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
    useCudatoolkitRunfile = strings.versionOlder cudaMajorMinorVersion "11.3.999";
    # The CUDNN used with TensorRT.
    # If null, the default cudnn derivation will be used.
    # If a version is specified, the cudnn derivation with that version will be used,
    # unless it is not available, in which case the default cudnn derivation will be used.
    cudnn =
      let
        desiredName = _cuda.lib.mkVersionedName "cudnn" constraints."cudnn".">=" or "";
      in
      if constraints."cudnn".">=" or null == null || (cudaPackages ? desiredName) then
        cudaPackages.cudnn
      else
        cudaPackages.${desiredName};
  };

  meta = prevAttrs.meta or { } // {
    homepage = "https://developer.nvidia.com/tensorrt";
    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ maintainers.aidalgol ];
    teams = prevAttrs.meta.teams or [ ];

    # Building TensorRT on Hydra is impossible because of the non-redistributable
    # license and because the source needs to be manually downloaded from the
    # NVIDIA Developer Program (see requireFile above).
    hydraPlatforms = lib.platforms.none;
  };
}
