{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.28";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "00w6xfcv960c98qvxv81gcbj8l1jiab9sggmdl77m19awwiyvwv3";
  };

  meta = with stdenv.lib; { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
