{ lib
, stdenv
, fetchurl
, libxml2
, libxslt
, itstool
, gnome3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "yelp-tools";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1c045c794sm83rrjan67jmsk20qacrw1m814p4nw85w5xsry8z30";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2
    libxslt
    itstool
    gnome3.yelp-xsl
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Yelp/Tools";
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = teams.gnome.members ++ (with maintainers; [ domenkozar ]);
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
