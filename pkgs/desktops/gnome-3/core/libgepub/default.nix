{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobjectIntrospection, gnome3
, webkitgtk, libsoup, libxml2, libarchive }:
stdenv.mkDerivation rec {
  name = "libgepub-${version}.2";
  version = "0.5";

  src = fetchurl {
    url = "mirror://gnome/sources/libgepub/${version}/${name}.tar.xz";
    sha256 = "0f1bczy3b00kj7mhm80xgpcgibh8h0pgcr46l4wifi45jacji0w4";
  };

  doCheck = true;

  checkPhase = "meson test";

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
  buildInputs = [ glib webkitgtk libsoup libxml2 libarchive ];

  meta = with stdenv.lib; {
    description = "GObject based library for handling and rendering epub documents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
