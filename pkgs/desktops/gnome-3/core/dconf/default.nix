{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "0.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/0.18/${name}.tar.xz";
    sha256 = "0mf921pnkhs8xn1dr2wxfq277vjsbkpl9cccv0gaz4460z31p6qh";
  };

  buildInputs = [ vala libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2
                  intltool docbook_xsl docbook_xsl_ns ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
