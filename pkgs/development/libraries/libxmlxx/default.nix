{ stdenv, fetchurl
, pkgconfig, libxml2, glibmm, perl }:
stdenv.mkDerivation rec {
  name = "libxml++-2.37.2";
  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/2.37/${name}.tar.xz";
    sha256 = "0fvpm95iapi5qrz6sil6vnqqdrsd7f9a16c415hzr44f2ji10gmv";
  };

  buildInputs = [ pkgconfig glibmm perl ];

  propagatedBuildInputs = [ libxml2 ];

  configureFlags = "--disable-documentation"; #doesn't build without this for some reason

  meta = {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.phreedom ];
  };
}