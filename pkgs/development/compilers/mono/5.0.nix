{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.0.1.1";
  sha256 = "064pgsmanpybpbhpam9jv9n8aicx6mlyb7a91yzh3kcksmqsxmj8";
})
