{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.6.2.16";
  sha256 = "190f7kcrm1y5x61s1xwdmjnwc3czsg50s3mml4xmix7byh3x2rc9";
})
