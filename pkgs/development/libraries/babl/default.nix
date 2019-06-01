{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.64";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "1gsqs5spgla86y9g11riryvw7015asik7y22maainl83nhq4sxxv";
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
