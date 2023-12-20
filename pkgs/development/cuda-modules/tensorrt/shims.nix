# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/release.nix
{package, redistArch}:
{
  featureRelease.${redistArch}.outputs = {
    bin = true;
    lib = true;
    static = true;
    dev = true;
    sample = true;
    python = true;
  };
  redistribRelease = {
    name = "TensorRT: a high-performance deep learning interface";
    inherit (package) version;
  };
}
