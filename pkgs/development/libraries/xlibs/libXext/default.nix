{stdenv, fetchurl, pkgconfig, xproto, xextensions, libX11}:

stdenv.mkDerivation {
  name = "libXext-6.4.3";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/libXext-6.4.3.tar.bz2;
    md5 = "b7117194e69867905da9701dff56f3ee";
  };
  buildInputs = [pkgconfig xproto xextensions libX11];
}
