{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "gnome-dictionary-3.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/3.10/${name}.tar.xz";
    sha256 = "258b60fe50f7d0580a7dc3bb83f7fe2f6f0597d4013d97ac083c3f062c350ed7";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 file
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-dictionary" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
