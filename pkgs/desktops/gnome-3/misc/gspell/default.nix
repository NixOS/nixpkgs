{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala, gobjectIntrospection }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [ enchant ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala gobjectIntrospection ];
  buildInputs = [ glib gtk3 isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
