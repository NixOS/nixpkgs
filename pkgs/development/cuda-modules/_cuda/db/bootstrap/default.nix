{ lib }:
{
  # See ./cuda.nix for documentation.
  inherit (import ./cuda.nix { inherit lib; })
    cudaCapabilityToInfo
    ;

  # See ./nvcc.nix for documentation.
  inherit (import ./nvcc.nix)
    nvccCompatibilities
    ;

  # See ./redist.nix for documentation.
  inherit (import ./redist.nix)
    redistNames
    redistSystems
    redistUrlPrefix
    ;

  /**
    The path to the CUDA packages root directory, for use with `callPackage` to create new package sets.

    # Type

    ```
    cudaPackagesPath :: Path
    ```
  */
  cudaPackagesPath = ./../../..;
}
