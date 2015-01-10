{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "getdata-0.8.6";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${name}.tar.bz2";
    sha256 = "1cxmyqg6m7346q37wrr05zmyip1qcgi4vpy3xki20nxwkaw37lz8";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://getdata.sourceforge.net/;
  };
}
