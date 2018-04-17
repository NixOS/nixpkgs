{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.46";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0nwyhvfca6m35wjcccvwca7fcihzgdfyc012qi703y5d3cxl1hmv";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
