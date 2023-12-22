# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/manifest.nix
{
  lib,
  package,
  # redistArch :: Optional String
  # String is null if the given architecture is unsupported.
  redistArch,
}:
{
  feature.cudnn = lib.optionalAttrs (redistArch != null) {
    ${redistArch}.outputs = {
      lib = true;
      static = true;
      dev = true;
    };
  };
  redistrib.cudnn = {
    name = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    inherit (package) version;
  };
}
