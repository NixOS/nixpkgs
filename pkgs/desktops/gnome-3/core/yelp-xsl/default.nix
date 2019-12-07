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
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1bdpgkzawhqmw52l6zx8czzg1ndfgcf1p44m2bxjdpqkc4afcgqc";
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
