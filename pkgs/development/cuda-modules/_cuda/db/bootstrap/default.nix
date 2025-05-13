{ lib }:

import ./static.nix
// {
  # See ./cuda.nix for documentation.
  inherit (import ./cuda.nix { inherit lib; })
    cudaCapabilityToInfo
    ;

  # See ./nvcc.nix for documentation.
  inherit (import ./nvcc.nix)
    nvccCompatibilities
    ;
}
