{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

let
  majorVersion = "3.16";
in
stdenv.mkDerivation rec {
  name = "dconf-editor-${version}";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${majorVersion}/${name}.tar.xz";
    sha256 = "0vl5ygbh8blbk3710w34lmhxxl4g275vzpyhjsq0016c597isp88";
  };

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
