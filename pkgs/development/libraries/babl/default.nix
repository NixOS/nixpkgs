{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.50";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0bavr2y4v88pip7vlca4kwmnksk2qxcvkkdp9jyfi6pzh701sb5m";
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
