{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.3.4";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "11zka6z9ncywyjr1gfm5cnii33ln7y3w6s86kiacchip2g7kw3f5";
  };

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    license = licenses.lgpl21;
    homepage = https://dl.matroska.org/downloads/libebml/;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

