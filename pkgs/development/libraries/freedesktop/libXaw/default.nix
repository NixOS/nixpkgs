{stdenv, fetchurl, pkgconfig, xproto, libX11, libXt, libXmu, libXpm}:

stdenv.mkDerivation {
  name = "libXaw-7.0.0";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXaw-7.0.0.tar.bz2;
    md5 = "a58fbb1b5af9e0cf23351b5b1e7b19dd";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11 libXt libXmu libXpm];
}
