{ stdenv, fetchurl, x11, libjpeg, libtiff, libungif, libpng, bzip2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "imlib2-1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${name}.tar.bz2";
    sha256 = "0x1j0ylpclkp8cfpwfpkjywqz124bqskyxbw8pvwzkv2gmrbwldg";
  };

  buildInputs = [ x11 libjpeg libtiff libungif libpng bzip2 ];

  nativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
    substituteInPlace imlib2-config.in \
      --replace "@my_libs@" ""
  '';

  meta = {
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
