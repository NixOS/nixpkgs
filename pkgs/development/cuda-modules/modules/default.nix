{ config, lib, ... }:
let
  inherit (lib) options types;
in
{
  imports = [
    ./generic
    ./gpus.nix
    ./nvcc-compatibilities.nix
    ./versions.nix
    # Always after generic
    ./cuda
    ./cudnn
    ./tensorrt
    ./cutensor
  ];

  # Flags are determined based on your CUDA toolkit by default.  You may benefit
  # from improved performance, reduced file size, or greater hardware support by
  # passing a configuration based on your specific GPU environment.
  # Please see the accompanying documentation or https://github.com/NixOS/nixpkgs/pull/205351

  options = {
    cudaSupport = options.mkOption {
      description = "Build packages with CUDA support";
      type = types.bool;
    };
    cudaCapabilities = options.mkOption {
      description = "CUDA capabilities (hardware generations) to build for";
      type = types.listOf config.generic.types.cudaCapability;
    };
    cudaForwardCompat = options.mkOption {
      description = "Build with forward compatibility gencode (+PTX) to support future GPU generations";
      type = types.bool;
    };
  };
}
