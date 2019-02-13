{ stdenv, intltool, fetchurl, pkgconfig
, itstool, libxml2, libxslt, gnome3 }:

stdenv.mkDerivation rec {
  name = "yelp-xsl-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0ffgp3ymcc11r9sdndliwwngljcy1mfqpfxsdfbm8rlcjg2k3vzw";
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
