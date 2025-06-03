# Shims to mimic the shape of ../modules/generic/manifests/{feature,redistrib}/release.nix
{
  package,
  # redistSystem :: String
  # String is "unsupported" if the given architecture is unsupported.
  redistSystem,
}:
{
  featureRelease = {
    inherit (package) minCudaVersion maxCudaVersion;
    ${redistSystem}.outputs = {
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
