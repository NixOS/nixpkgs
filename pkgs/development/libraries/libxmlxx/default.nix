{ stdenv, fetchurl
, pkgconfig, libxml2, glibmm, perl }:
stdenv.mkDerivation rec {
  name = "libxml++-2.30.1";
  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/2.30/${name}.tar.bz2";
    sha256 = "02mrib11cjx5fshdr8p1biwvyl0xfkf86b6nh8ashwv590v0wgs3";
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