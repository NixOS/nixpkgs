{ lib
, stdenv
, fetchurl
, libxml2
, libxslt
, itstool
, gnome3
, pkg-config
, meson
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "yelp-tools";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1bkanqp3qwmirv06mi99qv2acr5ba5rlhy9zlh0fyrfxygraqjv6";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    python3.pkgs.lxml
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
