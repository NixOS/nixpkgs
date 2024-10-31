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
  version = "6.0.19";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6gui";
    rev = finalAttrs.version;
    hash = "sha256-nqwkBMcCQiW4iqYhceTaSNNxoR5tvCNfjKUVVHkzN3A=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
    (fetchpatch {
      name = "fix-build-on-qt-6.8.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/dtk6gui/-/raw/b6b8521fd69c28dbca5f6e8d1d8258c904b6caf1/qt-6.8.patch";
      hash = "sha256-Fu5vwvKJGMW94JYoIPvDCeXs8WrAskQlVRX/3FYQFGY=";
    })
  ];

  postPatch = ''
    substituteInPlace src/util/dsvgrenderer.cpp \
      --replace-fail 'QLibrary("rsvg-2", "2")' 'QLibrary("${lib.getLib librsvg}/lib/librsvg-2.so")'
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
    maintainers = lib.teams.deepin.members;
  };
})
