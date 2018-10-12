{ stdenv, callPackage, fetchurl }:

callPackage ./build.nix {
  version = "4.9.0";

  SRC = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_0-devel.tgz";
    sha256 = "0wyfpjs244zrbrdil9rfkdgcawvms84z0r77qwhwadghma4dqgjf";
  };
  inherit stdenv;
}
