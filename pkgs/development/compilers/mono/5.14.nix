{ callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.14.0.177";
  sha256 = "164l30fkvfgs1rh663h7dnm1yp7425bi9x2lh2y6zml8h4pgmxfl";
  enableParallelBuilding = false;
})
