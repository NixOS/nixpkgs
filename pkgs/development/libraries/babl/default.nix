{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.48";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0596flzqzdlq4y6lsg34szh1ffgyccghp8y1k9h4d3jwymfd16xy";
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
