{ stdenv, intltool, fetchurl, pkgconfig, libxml2
, bash, gtk3, glib, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, mpfr, gmp }:

stdenv.mkDerivation rec {
  name = "gnome-calculator-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${gnome3.version}/${name}.tar.xz";
    sha256 = "068mnwkxliwafcfk70cz85fqna76vjj7kgsm4yqs4c1fd72gphmv";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  libxml2 gnome3.gtksourceview mpfr gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-calculator" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
