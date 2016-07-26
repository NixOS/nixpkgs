{ stdenv, callPackage }:
callPackage ./generic.nix (rec {
  version = "2.40.16";
  sha256 = "0bpz6gsq8xi1pb5k9ax6vinph460v14znch3y5yz167s0dmwz2yl";
})

