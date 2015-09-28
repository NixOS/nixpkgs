{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt, gnome3 }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${gnome3.version}/${name}.tar.xz";
    sha256 = "0jhpni4mmfvj3xf57rjm61nc8d0x66hz9gd1ywws5lh39g6fx59j";
  };

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
