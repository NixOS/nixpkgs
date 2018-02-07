{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.42";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "1wc7fyj9bfqfiwf1w33g3vv3wcl18pd9cxr9fc0iy391szrsynb8";
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
