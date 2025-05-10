# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/release.nix
{
  lib,
  package,
  # redistArch :: String
  # String is "unsupported" if the given architecture is unsupported.
  redistArch,
}:
{
  featureRelease = lib.optionalAttrs (redistArch != "unsupported") {
    inherit (package) minCudaVersion maxCudaVersion;
    ${redistArch}.outputs = {
      lib = true;
      static = true;
      dev = true;
    };
  };
  redistribRelease = {
    name = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    inherit (package) hash url version;
  };
}
