{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libowfat-0.32";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${name}.tar.xz";
    sha256 = "1hcqg7pvy093bxx8wk7i4gvbmgnxz2grxpyy7b4mphidjbcv7fgl";
  };

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    homepage = http://www.fefe.de/libowfat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
