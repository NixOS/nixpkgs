{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.44";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0zfy1jrwdp4ja2f1rqa2m46vx6nilm73f72d4d1c8d65vshgsqzl";
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
