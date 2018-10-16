{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.58";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0mgdii9v89ay0nra36cz9i0q7cqv8wi8hk01jsc4bf0rc1bsxjbr";
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
