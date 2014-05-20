{ stdenv, fetchurl, pkgconfig, gtk3, intltool
, gnome3, enchant, isocodes }:

stdenv.mkDerivation rec {
  name = "gtkhtml-4.6.6";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/4.6/${name}.tar.xz";
    sha256 = "145d23bbe729ff4ee7e7027bb5ff405b34822271327fdd81fe913134831374cd";
  };

  buildInputs = [ pkgconfig gtk3 intltool gnome3.gnome_icon_theme
                  gnome3.gsettings_desktop_schemas ];

  propagatedBuildInputs = [ enchant isocodes ];

}
