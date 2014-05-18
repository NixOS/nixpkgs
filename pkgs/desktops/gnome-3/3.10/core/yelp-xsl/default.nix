{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-3.10.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/yelp-xsl/3.10/${name}.tar.xz";
    sha256 = "59c6dee3999121f6ffd33a9c5228316b75bc22e3bd68fff310beb4eeff245887";
  };

  doCheck = true;

  buildInputs = [ pkgconfig intltool itstool libxml2 libxslt ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = with maintainers; [ lethalman ];
    # TODO license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
