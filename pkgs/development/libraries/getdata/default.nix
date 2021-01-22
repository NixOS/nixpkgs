{ lib, stdenv, fetchurl, libtool }:
stdenv.mkDerivation rec {
  pname = "getdata";
  version = "0.10.0";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${pname}-${version}.tar.xz";
    sha256 = "18xbb32vygav9x6yz0gdklif4chjskmkgp06rwnjdf9myhia0iym";
  };

  buildInputs = [ libtool ];

  meta = with lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://getdata.sourceforge.net/";
  };
}
