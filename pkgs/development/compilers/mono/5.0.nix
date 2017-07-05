{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.0.0.48";
  sha256 = "13n20wmijkhd7vm41lzz1n774rna67d94prl33bz1lly0idsciq0";
})
