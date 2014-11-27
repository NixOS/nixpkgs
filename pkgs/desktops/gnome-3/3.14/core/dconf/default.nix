{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

let
  majorVersion = "0.22";
in
stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${majorVersion}/${name}.tar.xz";
    sha256 = "13jb49504bir814v8n8vjip5sazwfwsrnniw87cpg7phqfq7q9qa";
  };

  buildInputs = [ vala libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2
                  intltool docbook_xsl docbook_xsl_ns makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/dconf-editor" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

    rm $out/lib/gio/modules/giomodule.cache
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
