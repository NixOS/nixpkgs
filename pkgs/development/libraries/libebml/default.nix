{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.3.5";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.xz";
    sha256 = "005a0ipqnfbsq47zrc61zszi439jw32q5xd6dc1jyb3lc0zl266q";
  };

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    license = licenses.lgpl21;
    homepage = https://dl.matroska.org/downloads/libebml/;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

