{stdenv, fetchurl, pkgconfig, libX11, libSM, patch}:

stdenv.mkDerivation {
  name = "libXt-0.1.4";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXt-0.1.4.tar.bz2;
    md5 = "32b6528c9deb058d1a9ed17ffa848df8";
  };
  buildInputs = [pkgconfig libX11 libSM patch];
  # This patch should become unnecessary soon; already been fixed in CVS.
  patches = [./patch];
}
