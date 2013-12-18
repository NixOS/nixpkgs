{ stdenv, fetchurl, x11, libjpeg, libtiff, libungif, libpng, bzip2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "imlib2-1.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${name}.tar.bz2";
    sha256 = "0nllbhf8vfwdm40z35yj27n83k2mjf5vbd62khad4f0qjf9hsw14";
  };

  buildInputs = [ x11 libjpeg libtiff libungif libpng bzip2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
