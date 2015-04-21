{ stdenv, intltool, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, libxslt, webkitgtk
, gnome3, librsvg, gdk_pixbuf, libsoup, docbook_xsl
, gobjectIntrospection, json_glib
, gmp, desktop_file_utils }:

stdenv.mkDerivation rec {
  name = "gnome-documents-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${gnome3.version}/${name}.tar.xz";
    sha256 = "154ssnyq4lwq2rsy3l5kqk8x1qjvn2j5gqm23i0aiw7qsbx5phrs";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxslt
                  docbook_xsl desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper gmp
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg evince
                  libsoup webkitgtk gjs gobjectIntrospection gnome3.rest
                  gnome3.tracker gnome3.libgdata gnome3.gnome_online_accounts
                  gnome3.gnome_desktop gnome3.libzapojit json_glib
                  hicolor_icon_theme gnome3.adwaita-icon-theme ];

  enableParallelBuilding = true;

  preFixup =
    ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib}/bin/gapplication"

    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --run "if [ -z \"\$XDG_CACHE_DIR\" ]; then XDG_CACHE_DIR=\$HOME/.cache; fi; if [ -w \"\$XDG_CACHE_DIR/..\" ]; then mkdir -p \"\$XDG_CACHE_DIR/gnome-documents\"; fi"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
