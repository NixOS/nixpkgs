{ stdenv, intltool, fetchurl, evince, gjs
, pkgconfig, gtk3, glib
, makeWrapper, itstool, libxslt, webkitgtk
, gnome3, librsvg, gdk_pixbuf, libsoup, docbook_xsl
, gobjectIntrospection, json_glib, inkscape, poppler_utils
, gmp, desktop_file_utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  configureFlags = [ "--enable-getting-started" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxslt
                  docbook_xsl desktop_file_utils inkscape poppler_utils
                  gnome3.gsettings_desktop_schemas makeWrapper gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg evince
                  libsoup webkitgtk gjs gobjectIntrospection gnome3.rest
                  gnome3.tracker gnome3.libgdata gnome3.gnome_online_accounts
                  gnome3.gnome_desktop gnome3.libzapojit json_glib
                  wrapGAppsHook ];

  enableParallelBuilding = true;

  preFixup = ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib}/bin/gapplication"

    gappsWrapperArgs+=(--run 'if [ -z "$XDG_CACHE_DIR" ]; then XDG_CACHE_DIR=$HOME/.cache; fi; if [ -w "$XDG_CACHE_DIR/.." ]; then mkdir -p "$XDG_CACHE_DIR/gnome-documents"; fi')
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
