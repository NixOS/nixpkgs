{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

let
  majorVersion = "0.24";
in
stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${majorVersion}/${name}.tar.xz";
    sha256 = "4373e0ced1f4d7d68d518038796c073696280e22957babb29feb0267c630fec2";
  };

  buildInputs = [ vala libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2
                  intltool docbook_xsl docbook_xsl_ns makeWrapper ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
