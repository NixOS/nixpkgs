{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  adwaita-qt,
  adwaita-qt6,
  glib,
  gtk3,
  qtbase,
  qtquickcontrols2 ? null,
  qtwayland,
  replaceVars,
  gsettings-desktop-schemas,
  useQt6 ? false,
}:

stdenv.mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "sha256-8hq+JapJPWOjS7ICkWnCglS8udqQ0+w45ajyyxfBIME=";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (replaceVars ./hardcode-gsettings.patch {
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
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
  ]
  ++ lib.optionals (!useQt6) [
    adwaita-qt
    qtquickcontrols2
  ]
  ++ lib.optionals useQt6 [
    adwaita-qt6
  ];

  # Qt setup hook complains about missing `wrapQtAppsHook` otherwise.
  dontWrapQtApps = true;

  cmakeFlags = [
    "-DGLIB_SCHEMAS_DIR=${glib.getSchemaPath gsettings-desktop-schemas}"
    "-DQT_PLUGINS_DIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"

    # Workaround CMake 4 compat
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.31")
  ]
  ++ lib.optionals useQt6 [
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
