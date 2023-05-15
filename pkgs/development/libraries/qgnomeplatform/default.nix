{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, adwaita-qt
, adwaita-qt6
, glib
, gtk3
, qtbase
, qt5
, qtwayland
, cinnamon
, substituteAll
, gsettings-desktop-schemas
, useQt6 ? false
}:

stdenv.mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "sha256-X+iJIbZL4/jKECIg2gTcenjzMA9nMy6gO6rNrAiVsKI=";
  };

  patches = [
    # Hardcode GSettings schema path
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
      cinnamon_gsettings_path = glib.getSchemaPath cinnamon.cinnamon-desktop;
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    qtbase
    qtwayland
  ] ++ lib.optionals (!useQt6) [
    qt5.qtquickcontrols2
    adwaita-qt
  ] ++ lib.optionals useQt6 [
    adwaita-qt6
  ];

  # Qt setup hook complains about missing `wrapQtAppsHook` otherwise.
  dontWrapQtApps = true;

  cmakeFlags = [
    "-DGLIB_SCHEMAS_DIR=${glib.getSchemaPath gsettings-desktop-schemas}"
    "-DQT_PLUGINS_DIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ] ++ lib.optionals useQt6 [
    "-DUSE_QT6=true"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = "https://github.com/FedoraQt/QGnomePlatform";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.linux;
  };
}
