{ stdenv
, gettext
, fetchurl
, pkgconfig
, itstool
, libxml2
, libxslt
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "yelp-xsl";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1hsfj3q3a3kca0cf9i02xlq2qd4vy12qsjb89hh4r6mp6c11rrag";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    libxml2
    libxslt
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp";
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = teams.gnome.members;
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
