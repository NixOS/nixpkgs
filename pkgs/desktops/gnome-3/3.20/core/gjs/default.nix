{ fetchurl, stdenv, pkgconfig, gnome3, gtk3, gobjectIntrospection
, spidermonkey_24, pango, readline, glib, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ libxml2 gobjectIntrospection pkgconfig gtk3 glib pango readline ];

  propagatedBuildInputs = [ spidermonkey_24 ];

  postInstall = ''
    sed 's|-lreadline|-L${readline.out}/lib -lreadline|g' -i $out/lib/libgjs.la
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
