{ callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.8.0.108";
  sha256 = "177khb06dfll0pcncr84vvibni7f8m5fgb30ndgsdjk25xfcbmzc";
  enableParallelBuilding = false;
})
