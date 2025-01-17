# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/release.nix
{
  lib,
  package,
  # redistArch :: String
  # String is `"unsupported"` if the given architecture is unsupported.
  redistArch,
}:
{
  featureRelease = lib.optionalAttrs (redistArch != "unsupported") {
    ${redistArch}.outputs = {
      bin = true;
      lib = true;
      static = true;
      dev = true;
      sample = true;
      python = true;
    };
  };
  redistribRelease = {
    name = "TensorRT: a high-performance deep learning interface";
    inherit (package) version;
  };
}
