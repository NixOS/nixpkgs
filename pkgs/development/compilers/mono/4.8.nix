{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.8.1.0";
  sha256 = "1vyvp2g28ihcgxgxr8nhzyzdmzicsh5djzk8dk1hj5p5f2k3ijqq";
})
