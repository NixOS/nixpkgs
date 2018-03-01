{ stdenv, intltool, fetchurl, pkgconfig, bash
, itstool, libxml2, libxslt, gnome3 }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-${version}";
  version = "3.20.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "dc61849e5dca473573d32e28c6c4e3cf9c1b6afe241f8c26e29539c415f97ba0";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "yelp-xsl"; attrPath = "gnome3.yelp-xsl"; };
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool itstool libxml2 libxslt ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = gnome3.maintainers;
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
