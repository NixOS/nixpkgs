{stdenv, fetchurl, pkgconfig, xproto, xextensions, libX11}:

stdenv.mkDerivation {
  name = "libXext-6.4.2";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXext-6.4.2.tar.bz2;
    md5 = "e7c5f5ac3db6d171f8938339f7617281";
  };
  buildInputs = [pkgconfig xproto xextensions libX11];
}
