{ stdenv, fetchurl
, pkgconfig, libxml2, glibmm, perl }:
stdenv.mkDerivation rec {
  name = "libxml++-3.0.0";
  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/3.0/${name}.tar.xz";
    sha256 = "0lkrajbdys5f6w6qwfijih3hnbk4c6809qx2mmxkb7bj2w269wrg";
  };

  buildInputs = [ pkgconfig glibmm perl ];

  propagatedBuildInputs = [ libxml2 ];

  meta = {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library, version 3";
    license = "LGPLv2+";
    maintainers = with stdenv.maintainers; [ ];
  };
}
