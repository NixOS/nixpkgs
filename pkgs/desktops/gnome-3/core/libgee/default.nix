{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "libgee-0.13.90";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgee/0.13/${name}.tar.xz";
    sha256 = "9496f8fb249f7850db32b50e8675998db8b5276d4568cbf043faa7e745d7b7d6";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
