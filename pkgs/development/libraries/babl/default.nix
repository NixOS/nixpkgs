{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.56";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0a2dvihah1j7qi5dp1qzzlwklcqnndmxsm7lc7i78g7c2yknrlla";
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
