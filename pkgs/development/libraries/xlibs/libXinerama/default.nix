{stdenv, fetchurl, pkgconfig, libX11, libXext, panoramixext}:

stdenv.mkDerivation {
  name = "libXinerama-1.0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libXinerama-1.0.2.tar.bz2;
    md5 = "637b2c5758d2de558670428d33178174";
  };
  buildInputs = [pkgconfig panoramixext];
  propagatedBuildInputs = [libX11 libXext];
}
