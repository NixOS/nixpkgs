{ stdenv, callPackage, fetchurl }:

callPackage ./build.nix {
  version = "4.9.2";
  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_2-devel.tgz";
    sha256 = "1xpjm3m1pxwj3n0g36lbb3p6wx2nc1iry95xc22pnq3m2374gjxv";
  };
  inherit stdenv;
}
