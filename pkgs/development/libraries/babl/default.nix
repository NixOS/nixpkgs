{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.60";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0kv0y12j4k9khrxqa7rryfb4ikcnrax6x4nwi70wnz05nv6fxld3";
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
