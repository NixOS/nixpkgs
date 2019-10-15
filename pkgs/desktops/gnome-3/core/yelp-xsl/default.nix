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
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1qjfw4s8yf4hmyqrcqy6q2rsnb8b2cl1qbq67m7n7pyiczp3l1p8";
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
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = gnome3.maintainers;
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
