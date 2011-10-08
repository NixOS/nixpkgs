{stdenv, fetchurl, pkgconfig, gtk, gettext, intltool, libgnomecanvas, libgnomeprint, gnomeicontheme}:

stdenv.mkDerivation {
  name = "libgnomeprintui-2.11.1";

  src = fetchurl {
    url = mirror://gnome/sources/libgnomeprintui/2.18/libgnomeprintui-2.18.4.tar.bz2;
    sha256 = "19d2aa95c9cb85f1ddd13464500217a76e2abce59281ec5d210e139c14dd7490";
  };

  buildInputs = [ pkgconfig gtk gettext intltool libgnomecanvas libgnomeprint gnomeicontheme];
}
