{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ vala libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2 gnome3.defaultIconTheme
                  intltool docbook_xsl docbook_xsl_ns makeWrapper gnome3.dconf ];

  preFixup = ''
    wrapProgram "$out/bin/dconf-editor" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
