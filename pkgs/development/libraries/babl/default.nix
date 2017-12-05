{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.38";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "11pfbyzq20596p9sgwraxspg3djg1jzz6wvz4bapf0yyr97jiyd0";
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
