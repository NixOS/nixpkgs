{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt, gnome3 }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${gnome3.version}/${name}.tar.xz";
    sha256 = "8f5b6793cd600f8308e4ac93da68009169fa6d590eb71ed4a8e98bafe541a87e";
  };

  doCheck = true;

  buildInputs = [ pkgconfig intltool itstool libxml2 libxslt ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = with maintainers; [ lethalman ];
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
