{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.54";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "01rad0sf9bkg7124qz5zdn08nl1q00yy5lg6ca3v053jblsg2asd";
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
