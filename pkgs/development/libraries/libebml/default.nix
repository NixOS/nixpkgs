{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.3.3";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "16alhwd1yz5bv3765xfn5azwk37805lg1f61195gjq8rlkd49yrm";
  };

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    license = licenses.lgpl21;
    homepage = http://dl.matroska.org/downloads/libebml/;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

