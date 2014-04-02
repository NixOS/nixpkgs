{ stdenv, intltool, fetchurl, pkgconfig, libxml2
, bash, gtk3, glib, hicolor_icon_theme, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-calculator-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/3.12/${name}.tar.xz";
    sha256 = "22882c770251203be85f728d73b0d3946728774fd437cf460cd6d958fc4b4dc5";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  libxml2 gnome3.gtksourceview
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  installFlags = "gsettingsschemadir=\${out}/share/gnome-calculator/glib-2.0/schemas/";

  postInstall = ''
    wrapProgram "$out/bin/gnome-calculator" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/gnome-calculator:$XDG_ICON_DIRS"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
