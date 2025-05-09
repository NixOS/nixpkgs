let
  lib = import ../../../../lib;
in
lib.fixedPoints.makeExtensible (final: {
  data = import ./data {
    inherit lib;
    cudaLib = final;
  };
  utils = import ./utils {
    inherit lib;
    cudaLib = final;
  };
})
