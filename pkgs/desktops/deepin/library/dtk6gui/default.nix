{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  doxygen,
  qt6Packages,
  dtk6core,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6gui";
  version = "6.0.33";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6gui";
    rev = finalAttrs.version;
    hash = "sha256-ZnRhrlgrQ7Vusod2diFwVEVnNGHYNq5Ij12GbW6LXWc=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/dtk6gui/-/raw/ae64c77a73cdea069579ecf6833be63635237180/qt-6.9.patch";
      hash = "sha256-45L3ZQ9Hv7tLdDjtazLhVl8XgKBtcHL3CT2nw6GkqgM=";
    })
  ];

  postPatch = ''
    substituteInPlace src/util/dsvgrenderer.cpp \
      --replace-fail 'QLibrary("rsvg-2", "2")' 'QLibrary("${lib.getLib librsvg}/lib/librsvg-2.so")'
    sed '1i#include <pwd.h>' \
      -i 'src/kernel/dguiapplicationhelper.cpp'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtwayland
    librsvg
  ];

  propagatedBuildInputs = [
    dtk6core
    qt6Packages.qtimageformats
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${finalAttrs.version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
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
    for binary in $out/libexec/dtk6/DGui/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = {
    description = "Deepin Toolkit, gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtk6gui";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
})
