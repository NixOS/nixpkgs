{ stdenv, fetchurl, pkgconfig, gtk3, intltool
, gnome3, enchant, isocodes }:

let
  majorVersion = "4.8";
in
stdenv.mkDerivation rec {
  name = "gtkhtml-${majorVersion}.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${majorVersion}/${name}.tar.xz";
    sha256 = "2ff5bbec4d8e7eca66a36f7e3863a104e098ce9b58e6d0374de7cb80c3d93e8d";
  };

  buildInputs = [ pkgconfig gtk3 intltool gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas ];

  propagatedBuildInputs = [ enchant isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
