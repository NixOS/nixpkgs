{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "getdata-0.8.5";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${name}.tar.bz2";
    sha256 = "0km6hbv18m9g8fxdqfcmk3bjr47w856v4hbrxpd609m6rk0j40zf";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://getdata.sourceforge.net/;
  };
}
