{ stdenv, fetchurl, pkgconfig, meson, ninja, valadoc
, gnome3, glib, json-glib, libarchive, libsoup, gobjectIntrospection }:

stdenv.mkDerivation rec {
  major = "0.6";
  minor = "5";
  version = "${major}.${minor}";

  name = "libhttpseverywhere-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libhttpseverywhere/${major}/libhttpseverywhere-${version}.tar.xz";
    sha256 = "0ksf6vqjyjii29dvy5147dmgqlqsq4d70xxai0p2prkx4jrwgj3z";
  };

  nativeBuildInputs = [ gnome3.vala gobjectIntrospection meson ninja pkgconfig valadoc ];
  buildInputs = [ glib gnome3.libgee json-glib libsoup libarchive ];

  mesonFlags = "-Denable_valadoc=true";

  doCheck = true;

  checkPhase = "./httpseverywhere_test";

  outputs = [ "out" "devdoc" ];

  meta = {
    description = "library to use HTTPSEverywhere in desktop applications";
    homepage    = https://git.gnome.org/browse/libhttpseverywhere;
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
