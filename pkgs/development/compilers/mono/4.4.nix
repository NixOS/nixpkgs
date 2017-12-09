{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.4.2.11";
  sha256 = "0cxnypw1j7s253wr5hy05k42ghgg2s9qibp10kndwnp5bv12q34h";
  enableParallelBuilding = false; # #32386, https://hydra.nixos.org/build/65565737
})
