{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "recordext-1.13-cvs";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/recordext-1.13.tar.bz2;
    md5 = "dcb2519a76ce238507e777bd79b67ab5";
  };
}
