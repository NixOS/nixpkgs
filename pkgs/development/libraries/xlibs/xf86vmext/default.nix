{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xf86vmext-2.2-cvs";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xf86vmext-2.2-cvs.tar.bz2;
    md5 = "5a5818accd51799626b8c6db429907e0";
  };
}
