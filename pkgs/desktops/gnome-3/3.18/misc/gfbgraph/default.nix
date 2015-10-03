{ stdenv, intltool, fetchurl, pkgconfig, glib
, gnome3, libsoup, json_glib }:

stdenv.mkDerivation rec {
  name = "gfbgraph-0.2.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gfbgraph/0.2/${name}.tar.xz";
    sha256 = "66c7b1c951863565c179d0b4b5207f27b3b36f80afed9f6a9acfc5fc3ae775d4";
  };

  buildInputs = [ pkgconfig glib gnome3.gnome_online_accounts ];
  propagatedBuildInputs = [ libsoup json_glib gnome3.rest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
