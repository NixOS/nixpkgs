{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.52";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0v7pkr3qd5jnn0pra88d90ixkl5h9ngg6w660nn1cgh4zjh19xs0";
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
