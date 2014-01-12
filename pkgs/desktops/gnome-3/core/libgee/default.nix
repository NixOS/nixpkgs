{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "libgee-0.13.4";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgee/0.13/${name}.tar.xz";
    sha256 = "1gzyx8gy5m6r8km3xbb1kszz0v3p9vsbzwb78pf3fw122gwbjj4k";
  };

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
