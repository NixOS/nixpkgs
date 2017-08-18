{ fetchurl, stdenv, pkgconfig, gnome3, gtk3, gobjectIntrospection
, spidermonkey_31, pango, readline, glib, libxml2, dbus }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ libxml2 gobjectIntrospection pkgconfig gtk3 glib pango readline dbus ];

  propagatedBuildInputs = [ spidermonkey_31 ];

  postInstall = ''
    sed 's|-lreadline|-L${readline.out}/lib -lreadline|g' -i $out/lib/libgjs.la
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
