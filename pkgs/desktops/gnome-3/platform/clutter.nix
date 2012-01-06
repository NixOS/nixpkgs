{ stdenv, fetchurl, glib, xz, pkgconfig, mesa, libX11, libXext, libXfixes
, libXdamage, libXcomposite, libXi, cogl, pango, atk, json_glib }:

stdenv.mkDerivation {
  name = "clutter-1.8.2";

  src = fetchurl {
    url = mirror://gnome/sources/clutter/1.8/clutter-1.8.2.tar.xz;
    sha256 = "0bzsvnharawfg525lpavrp55mq4aih5nb01dwwqwnccg8hk9z2fw";
  };

  buildNativeInputs = [ xz pkgconfig ];
  buildInputs = [ libX11 glib mesa libXext libXfixes libXdamage libXcomposite
    libXi cogl pango atk json_glib ];
}
