{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libowfat-0.31";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${name}.tar.xz";
    sha256 = "04lagr62bd2cr0k8h59qfnx2klh2cf73k5kxsx8xrdybzhfarr6i";
  };

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    homepage = http://www.fefe.de/libowfat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
