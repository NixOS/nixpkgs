# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/manifest.nix
{
  lib,
  package,
  # redistArch :: Optional String
  # String is null if the given architecture is unsupported.
  redistArch,
}:
{
  feature.tensorrt = lib.optionalAttrs (redistArch != null) {
    ${redistArch}.outputs = {
      bin = true;
      lib = true;
      static = true;
      dev = true;
      sample = true;
      python = true;
    };
  };
  redistrib.tensorrt = {
    name = "TensorRT: a high-performance deep learning interface";
    inherit (package) version;
  };
}
