{ lib }:
lib.fixedPoints.makeExtensible (final: {
  data = import ./data.nix {
    inherit lib;
    cudaLib = final;
  };
  utils = import ./utils.nix {
    inherit lib;
    cudaLib = final;
  };
})
