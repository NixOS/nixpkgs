{ stdenv, intltool, fetchurl, pkgconfig, glib
, gnome3, libsoup, json_glib }:

stdenv.mkDerivation rec {
  name = "gfbgraph-0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gfbgraph/0.2/${name}.tar.xz";
    sha256 = "534ca84920445b9d89e2480348eedde3ce950db3628ae0a79703e8f2d52fa724";
  };

  buildInputs = [ pkgconfig glib libsoup gnome3.gnome_online_accounts
                  json_glib gnome3.rest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
