{
  cudaOlder,
  cudaPackages,
  cudaVersion,
  lib,
  patchelf,
  stdenv,
  utils,
}:
let
  inherit (lib.attrsets) attrByPath;
  inherit (lib.lists) optionals;
  inherit (lib.meta) getExe';
  inherit (lib.strings) concatStringsSep optionalString;
  inherit (lib.versions) majorMinor;
  inherit (utils) getRedistArch majorMinorPatch mkVersionedPackageName;
  # targetArch :: String
  targetArch = getRedistArch stdenv.hostPlatform.system;
  majorMinorVersionsEqual = a: b: majorMinor a == majorMinor b;
in
finalAttrs:
let
  constraints = attrByPath [
    finalAttrs.version
    targetArch
  ] { } (builtins.import ./constraints.nix);
  cudnn =
    let
      desiredName = mkVersionedPackageName {
        packageName = "cudnn";
        redistName = "cudnn";
        version = constraints.cudnnVersion;
      };
    in
    cudaPackages.${desiredName} or cudaPackages.cudnn;

  cudaMismatch =
    constraints ? cudaVersion && !(majorMinorVersionsEqual cudaVersion constraints.cudaVersion);
  cudnnMismatch =
    constraints ? cudnnVersion && !(majorMinorVersionsEqual cudnn.version constraints.cudnnVersion);
in
prevAttrs: {
  allowFHSReferences = true;

  # Useful for inspecting why something went wrong.
  brokenConditions = prevAttrs.brokenConditions // {
    "CUDA version mismatch" = cudaMismatch;
    "CUDNN version mismatch" = cudnnMismatch;
  };

  badPlatformsConditions = prevAttrs.badPlatformsConditions // {
    "Unsupported platform" = targetArch == "unsupported";
  };

  buildInputs =
    prevAttrs.buildInputs
    ++ [ cudnn.lib ]
    ++ optionals finalAttrs.passthru.useCudatoolkitRunfile [ cudaPackages.cudatoolkit.lib ]
    ++ optionals (!finalAttrs.passthru.useCudatoolkitRunfile) [ cudaPackages.cuda_cudart.lib ];

  preInstall =
    let
      inherit (stdenv.hostPlatform) parsed;
      # x86_64-linux-gnu
      targetString = concatStringsSep "-" [
        parsed.cpu.name
        parsed.kernel.name
        parsed.abi.name
      ];
    in
    (prevAttrs.preInstall or "")
    + optionalString (targetArch != "unsupported") ''
      # Replace symlinks to bin and lib with the actual directories from targets.
      for dir in bin lib; do
        # Only replace if the symlink exists.
        [ -L "$dir" ] || continue
        rm "$dir"
        mv "targets/${targetString}/$dir" "$dir"
      done
    '';

  # Tell autoPatchelf about runtime dependencies.
  postFixup =
    let
      versionTriple = majorMinorPatch finalAttrs.version;
    in
    (prevAttrs.postFixup or "")
    + ''
      ${getExe' patchelf "patchelf"} --add-needed libnvinfer.so \
        "$lib/lib/libnvinfer.so.${versionTriple}" \
        "$lib/lib/libnvinfer_plugin.so.${versionTriple}" \
        "$lib/lib/libnvinfer_builder_resource.so.${versionTriple}"
    '';

  passthru = prevAttrs.passthru // {
    useCudatoolkitRunfile = cudaOlder "11.4";
    # The CUDNN used with TensorRT.
    # If null, the default cudnn derivation will be used.
    # If a version is specified, the cudnn derivation with that version will be used,
    # unless it is not available, in which case the default cudnn derivation will be used.
    inherit cudnn;
  };

  meta = prevAttrs.meta // {
    description = "TensorRT: An SDK for High-Performance Inference on NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/tensorrt";
    maintainers = prevAttrs.meta.maintainers ++ [ lib.maintainers.aidalgol ];
    license = lib.licenses.unfreeRedistributable // {
      shortName = "TensorRT EULA";
      name = "TensorRT SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/deeplearning/tensorrt/sla/index.html";
    };
  };
}
