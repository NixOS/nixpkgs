{ lib, stdenv
, gettext
, fetchurl
, pkg-config
, itstool
, libxml2
, libxslt
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "yelp-xsl";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ryzvkcgxp7xi0icmpdl2rinjn904s8imbxdi6wshzxblqymc8dk";
  };

  nativeBuildInputs = [
    pkg-config
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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp";
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    maintainers = teams.gnome.members;
    license = [licenses.gpl2 licenses.lgpl2];
    platforms = platforms.linux;
  };
}
