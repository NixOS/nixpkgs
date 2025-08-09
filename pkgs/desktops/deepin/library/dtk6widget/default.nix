{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  doxygen,
  qt6Packages,
  dtk6gui,
  cups,
  libstartup_notification,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6widget";
  version = "6.0.33";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6widget";
    rev = finalAttrs.version;
    hash = "sha256-CSsN/6Geban/l6Rp5NuxIUomgTlqXyvttafTbjZIwSc=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/dtk6widget/-/raw/ce8f89bbed6ebd4659c7f964f158857ebfdee01c/qt-6.9.patch";
      hash = "sha256-LlFBXuoPxuszO9bkXK1Cy6zMTSnlh33UnmlKMJk3QH0=";
    })
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
  ]
  ++ (with qt6Packages; [
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

  outputs = [
    "out"
    "dev"
    "doc"
  ];

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
    teams = [ lib.teams.deepin ];
  };
})
