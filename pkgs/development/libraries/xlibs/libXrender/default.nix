{stdenv, fetchurl, pkgconfig, libX11, renderext}:

stdenv.mkDerivation {
  name = "libXrender-0.8.4";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXrender-0.8.4.tar.bz2;
    md5 = "c745339dbe5f05cff8950b71a739e34c";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 renderext];
}
