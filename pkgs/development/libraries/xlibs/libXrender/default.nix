{stdenv, fetchurl, pkgconfig, libX11, renderext}:

stdenv.mkDerivation {
  name = "libXrender-0.9.0";
  src = fetchurl {
    url = http://xlibs.freedesktop.org/release/libXrender-0.9.0.tar.bz2;
    md5 = "ce7cda009aa0b10a73637941d44ae789";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 renderext];
}
