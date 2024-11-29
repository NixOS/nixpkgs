{ lib
, fetchurl
, libxml2
, libxslt
, itstool
, gnome
, pkg-config
, meson
, ninja
, python3
, yelp-xsl
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yelp-tools";
  version = "42.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "PklqQCDUFFuZ/VCKJfoJM2pQOk6JAAKEIecsaksR+QU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  propagatedBuildInputs = [
    libxml2 # xmllint required by yelp-check.
    libxslt # xsltproc required by yelp-build and yelp-check.
  ];

  buildInputs = [
    itstool # build script checks for its presence but I am not sure if anything uses it
    yelp-xsl
  ];

  pythonPath = [
    python3.pkgs.lxml
  ];

  strictDeps = false; # TODO: Meson cannot find xmllint oherwise. Maybe add it to machine file?

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/yelp-tools";
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = teams.gnome.members ++ (with maintainers; [ domenkozar ]);
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
