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
, qtwayland
, substituteAll
, gsettings-desktop-schemas
, useQt6 ? false
}:

stdenv.mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "sha256-DaIBtWmce+58OOhqFG5802c3EprBAtDXhjiSPIImoOM=";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })

    # Backport cursor fix for Qt6 apps
    # Ajusted from https://github.com/FedoraQt/QGnomePlatform/pull/138
    ./qt6-cursor-fix.patch
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
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
