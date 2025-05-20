let
  lib = import ../../../../lib;
in
lib.fixedPoints.makeExtensible (final: {
  cudaData = import ./data {
    inherit lib;
    inherit (final) cudaData;
  };
  cudaFixups = import ./fixups { inherit lib; };
  cudaLib = import ./lib {
    inherit lib;
    inherit (final) cudaData cudaLib;
  };
})
