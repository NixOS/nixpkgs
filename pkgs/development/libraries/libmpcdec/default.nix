{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmpcdec-1.2.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libmpcdec-1.2.2.tar.bz2;
    md5 = "f14e07285b9b102a806649074c1d779b";
  };
}
