{stdenv, fetchurl, pkgconfig, libX11, libXext}:

stdenv.mkDerivation {
  name = "libXv-2.2.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libXv-2.2.2.tar.bz2;
    md5 = "cdd6a79bac8807da83c008dac42fdddb";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libXext];
}
