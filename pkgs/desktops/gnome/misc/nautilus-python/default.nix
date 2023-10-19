{ stdenv
, lib
, substituteAll
, fetchurl
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, python3
, nautilus
, gnome
}:

stdenv.mkDerivation rec {
  pname = "nautilus-python";
  version = "4.0";

  outputs = [ "out" "dev" "doc" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus-python/${lib.versions.majorMinor version}/nautilus-python-${version}.tar.xz";
    sha256 = "FyQ9Yut9fYOalGGrjQcBaIgFxxYaZwXmFBOljsJoKBo=";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (substituteAll {
      src = ./fix-paths.patch;
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    python3
    python3.pkgs.pygobject3
    nautilus
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Python bindings for the Nautilus Extension API";
    homepage = "https://wiki.gnome.org/Projects/NautilusPython";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
