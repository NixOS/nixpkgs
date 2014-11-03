{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libowfat-0.29";

  src = fetchurl {
    url = "http://dl.fefe.de/${name}.tar.bz2";
    sha256 = "09v4phf1d4y617fdqwn214jmkialf7xqcsyx3rzk7x5ysvpbvbab";
  };

  makeFlags = "prefix=$(out)";
  
  meta = with stdenv.lib; {
    homepage = http://www.fefe.de/libowfat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}