# Compile/link regressions for both supported release families and CPU roles.
# The shared GPU capability is supported by both toolkits; full workload/GPU
# validation uses the machine-specific capabilities in rebuild.nix instead.
{
  source ? ../../../..,
}:
let
  lib = import (source + /lib);
  names = [
    "component-hook"
    "cudart-pkg-config"
    "cudatoolkit"
    "backend-stdenv"
    "scope"
    "nvcc-backend"
    "nvcc-cmake"
    "nvcc-data-outputs"
    "nvcc-fortify"
    "nvcc-hook"
    "nvcc-outputs"
    "nvcc-roles"
    "nvcc-runtime"
    "redist-outputs"
  ];
  role =
    cross:
    let
      pkgs = import source {
        localSystem = "x86_64-linux";
        crossSystem = if cross then "aarch64-linux" else null;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ "8.9" ];
          cudaForwardCompat = false;
        };
      };
    in
    lib.genAttrs [ "12_9" "13_3" ] (
      release:
      let
        cuda = pkgs."cudaPackages_${release}";
      in
      lib.genAttrs names (name: cuda.tests.${name})
      // {
        stubs = cuda.tests.redist-outputs.tests.stubs;
        redist-propagation = cuda.tests.redist-outputs.tests.propagation;
        cudart-no-compiler = cuda.cuda_cudart.tests.no-compiler;
        cudart-dev-headers = cuda.tests.cudart-pkg-config.tests.dev-headers;
        cudart-bin-headers = cuda.tests.cudart-pkg-config.tests.bin-headers;
        nvcc-direct-bin = cuda.tests.nvcc-outputs.tests.direct-bin;
      }
    );
in
{
  native = role false;
  cross = role true;
}
