{ stdenv, callPackage, fetchgit }:

callPackage ./build.nix {
  version = "unstable-2018-08-06";
# git-version = "4.8.9-77-g91a4ad2c";
  SRC = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "91a4ad2c28375f067adedcaa61f9d66a4b536f4f";
    sha256 = "0px1ipvhh0hz8n38h6jv4y1nn163j8llvcy4l7p3hkdns5czwy1p";
  };
  inherit stdenv;
}
