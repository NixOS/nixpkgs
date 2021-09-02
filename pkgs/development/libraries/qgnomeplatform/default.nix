{ mkDerivation
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, adwaita-qt
, glib
, gtk3
, qtbase
, pantheon
, substituteAll
, gsettings-desktop-schemas
}:

mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "C/n8i5j0UWfxhP10c4j89U+LrpPozXnam4fIPYMXZAA=";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    adwaita-qt
    glib
    gtk3
    qtbase
  ];

  cmakeFlags = [
    "-DGLIB_SCHEMAS_DIR=${glib.getSchemaPath gsettings-desktop-schemas}"
    "-DQT_PLUGINS_DIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = "https://github.com/FedoraQt/QGnomePlatform";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.linux;
  };
}
