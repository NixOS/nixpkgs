{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.10.0.160";
  sha256 = "1n7qr33rs8gsv4iigpl1yhdl5s7hgf9pb3vh12zzvd5z0hakwz8n";
  enableParallelBuilding = false;
})
