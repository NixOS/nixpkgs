{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "getdata-${version}";
  version = "0.9.4";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${name}.tar.xz";
    sha256 = "0kikla8sxv6f1rlh77m86dajcsa7b1029zb8iigrmksic27mj9ja";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://getdata.sourceforge.net/;
  };
}
