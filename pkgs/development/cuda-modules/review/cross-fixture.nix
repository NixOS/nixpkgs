# Ordinary package selection for native and x86_64 -> AArch64 integration checks.
# Package fixes belong to their owning expressions; no diagnostic overrides.
{
  source ? ../../../..,
  cross ? true,
  cudaCapabilities ? if cross then [ "12.1a" ] else [ "8.9" ],
}:
let
  pkgs = import source {
    localSystem = "x86_64-linux";
    crossSystem = if cross then "aarch64-linux" else null;
    config = {
      allowUnfree = true;
      cudaSupport = true;
      inherit cudaCapabilities;
      cudaForwardCompat = false;
    };
  };
  cuda = pkgs.cudaPackages_13_3;
in
{
  inherit cuda;
  mpi = cuda.pkgs.mpi;
  nvshmem = cuda.libnvshmem;
  torch = cuda.pkgs.python3Packages.torch;
  metadata = {
    mpi = cuda.pkgs.mpi.drvPath;
    cudart = cuda.pkgs.cudaPackages.cuda_cudart.version;
    configureFlags = cuda.pkgs.mpi.configureFlags;
    nativeBuildInputs = map (x: x.name) cuda.pkgs.mpi.nativeBuildInputs;
    buildInputs = map (x: x.name) cuda.pkgs.mpi.buildInputs;
  };
}
