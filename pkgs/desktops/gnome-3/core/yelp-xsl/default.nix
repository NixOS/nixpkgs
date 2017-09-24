{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = [ pkgconfig intltool itstool libxml2 libxslt ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = gnome3.maintainers;
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
