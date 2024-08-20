{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, doxygen
, qt6Packages
, dtk6gui
, cups
, libstartup_notification
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6widget";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6widget";
    rev = finalAttrs.version;
    hash = "sha256-6H3Dtdyq/adb3jz9lGaKmOguXqvhvZn1/G7+YajyF2k=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  postPatch = ''
    substituteInPlace src/widgets/dapplication.cpp \
      --replace-fail "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);" \
                "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation) << \"$out/share\";"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    cups
    libstartup_notification
  ] ++ (with qt6Packages; [
    qtbase
    qtmultimedia
    qtsvg
  ]);

  propagatedBuildInputs = [ dtk6gui ];

  cmakeFlags = [
    "-DDTK_VERSION=${finalAttrs.version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${lib.getBin qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

  postFixup = ''
    for binary in $out/lib/dtk6/DWidget/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = {
    description = "Deepin graphical user interface library";
    homepage = "https://github.com/linuxdeepin/dtk6widget";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
})
