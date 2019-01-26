{ stdenv, callPackage, fetchurl }:

callPackage ./build.nix {
  version = "4.9.1";
  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_1-devel.tgz";
    sha256 = "10kzv568gimp9nzh5xw0h01vw50wi68z3awfp9ibqrpq2l0n7mw7";
  };
  inherit stdenv;
}
