{stdenv, fetchurl, pkgconfig, libX11, renderext}:

stdenv.mkDerivation {
  name = "libXrender-0.8.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libXrender-0.8.4.tar.bz2;
    md5 = "c745339dbe5f05cff8950b71a739e34c";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 renderext];
}
