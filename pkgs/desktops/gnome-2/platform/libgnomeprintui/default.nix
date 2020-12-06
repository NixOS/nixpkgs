{stdenv, fetchurl, pkgconfig, gtk2, gettext, intltool, libgnomecanvas, libgnomeprint, gnome-icon-theme}:

stdenv.mkDerivation {
  name = "libgnomeprintui-2.18.6";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeprintui/2.18/libgnomeprintui-2.18.6.tar.bz2";
    sha256 = "0spl8vinb5n6n1krnfnr61dwaxidg67h8j94z9p59k2xdsvfashm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 gettext intltool libgnomecanvas libgnomeprint gnome-icon-theme];
}
