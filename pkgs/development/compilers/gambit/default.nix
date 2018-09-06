{ stdenv, callPackage, fetchurl }:

callPackage ./build.nix {
  version = "4.8.9";

  SRC = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-v4_8_9-devel.tgz";
    sha256 = "1gwzz1ag9hlv266nvfq1bhwzrps3f2yghhffasjjqy8i8xwnry5p";
  };
  inherit stdenv;
}
