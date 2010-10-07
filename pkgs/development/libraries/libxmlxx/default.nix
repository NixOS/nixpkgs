{ stdenv, fetchurl
, pkgconfig, libxml2, glibmm, perl }:
stdenv.mkDerivation rec {
  name = "libxml++-2.30.0";
  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/2.30/${name}.tar.bz2";
    sha256 = "1hgpw9lld0k6z34kxrapz8dxf3cbgnnhkx6himnvw9ax3qf7p5gk";
  };

  buildInputs = [ pkgconfig glibmm perl ];

  propagatedBuildInputs = [ libxml2 ];

  configureFlags = "--disable-documentation"; #doesn't build without this for some reason

  meta = {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library";
    license = "LGPLv2+";
    maintainers = [ stdenv.lib.maintainers.phreedom ];
  };
}