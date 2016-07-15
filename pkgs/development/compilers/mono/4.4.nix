{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.4.1.0";
  sha256 = "0jibyvyv2jy8dq5ij0j00iq3v74r0y90dcjc3dkspcfbnn37cphn";
})
