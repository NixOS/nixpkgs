{stdenv, fetchurl, pkgconfig, libX11}:

stdenv.mkDerivation {
  name = "libXi-6.0.1";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/libXi-6.0.1.tar.bz2;
    md5 = "7e935a42428d63a387b3c048be0f2756";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11];
}
