{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, gtk3
, glib
, qtbase
, cmake
, qmake
, qtx11extras
, pantheon
, adwaita-qt
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
    sha256 = "sha256-C/n8i5j0UWfxhP10c4j89U+LrpPozXnam4fIPYMXZAA=";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    qmake
  ];

  buildInputs = [
    glib
    gtk3
    qtbase
    qtx11extras
    gsettings-desktop-schemas
    adwaita-qt
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
