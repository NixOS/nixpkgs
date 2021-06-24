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
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-GTtqvUaXt7Qh6Yw21NMTXaCw/bUapT5gLtNo3YTR/QM=";
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
    license = with licenses; [
      # See https://gitlab.gnome.org/GNOME/yelp-xsl/blob/master/COPYING
      # Stylesheets
      lgpl2Plus
      # Icons, unclear: https://gitlab.gnome.org/GNOME/yelp-xsl/issues/25
      gpl2
      # highlight.js
      bsd3
    ];
    platforms = platforms.unix;
  };
}
