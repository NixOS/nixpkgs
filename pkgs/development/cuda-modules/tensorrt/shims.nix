# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/release.nix
{
  package,
  # redistSystem :: String
  # String is `"unsupported"` if the given architecture is unsupported.
  redistSystem,
}:
{
  featureRelease = {
    inherit (package) cudnnVersion minCudaVersion maxCudaVersion;
    ${redistSystem}.outputs = {
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
    inherit (package) hash filename version;
  };
}
