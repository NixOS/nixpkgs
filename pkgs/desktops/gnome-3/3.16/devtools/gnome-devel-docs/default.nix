{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-devel-docs-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${gnome3.version}/${name}.tar.xz";
    sha256 = "1jkh40ya5mqss57p27b1hv77x5qis4zc377pyvzqa5wkzrvd0nls";
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/GNOME/gnome-devel-docs;
    description = "Developer documentation for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
