{stdenv, fetchurl, pkgconfig, xproto}:

stdenv.mkDerivation {
  name = "libXau-0.1.1";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXau-0.1.1.tar.bz2;
    md5 = "3d747ada4a7d17538fa21c62d5608656";
  };
  buildInputs = [pkgconfig xproto];
}
