{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/3.12/${name}.tar.xz";
    sha256 = "dd0b8af338b1cdae50444273d7c761e3f511224421487311103edc95a4493656";
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
