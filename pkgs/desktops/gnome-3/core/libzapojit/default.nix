{ stdenv, fetchurl, pkgconfig, glib, intltool, json-glib, rest, libsoup, gtk, gnome-online-accounts }:

stdenv.mkDerivation rec {
  name = "libzapojit-0.0.3";

  src = fetchurl {
    url = "mirror://gnome/sources/libzapojit/0.0/${name}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib intltool json-glib rest libsoup gtk gnome-online-accounts ];

  meta = with stdenv.lib; {
    description = "GObject wrapper for the SkyDrive and Hotmail REST APIs";
    platforms = platforms.linux;
  };
}
