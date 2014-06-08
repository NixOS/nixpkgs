{ stdenv, intltool, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, libxslt, webkitgtk
, gnome3, librsvg, gdk_pixbuf, libsoup, docbook_xsl
, gobjectIntrospection, json_glib
, gmp, desktop_file_utils }:

stdenv.mkDerivation rec {
  name = "gnome-documents-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/3.12/${name}.tar.xz";
    sha256 = "6d0df1d90781d56992ed5d5c2591833e89e3aa756ccab63f82dd935185ce5a53";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxslt
                  docbook_xsl desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper gmp
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg evince
                  libsoup webkitgtk gjs gobjectIntrospection gnome3.rest
                  gnome3.tracker gnome3.libgdata gnome3.gnome_online_accounts
                  gnome3.gnome_desktop gnome3.libzapojit json_glib
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  enableParallelBuilding = true;

  preFixup =
    let
      libPath = stdenv.lib.makeLibraryPath
        [ evince gtk3 gnome3.tracker gnome3.gnome_online_accounts ];
    in
    ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib}/bin/gapplication"

    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix LD_LIBRARY_PATH ":" "${libPath}" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --run "if [ -z \"\$XDG_CACHE_DIR\" ]; then XDG_CACHE_DIR=\$HOME/.cache; fi; if [ -w \"\$XDG_CACHE_DIR/..\" ]; then mkdir -p \"\$XDG_CACHE_DIR/gnome-documents\"; fi"
    done
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
