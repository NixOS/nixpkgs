{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  doxygen,
  qt6Packages,
  lshw,
  libuchardet,
  dtkcommon,
  dtk6log,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6core";
  version = "6.0.33";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6core";
    rev = finalAttrs.version;
    hash = "sha256-AmGQoDt9qp0m0iV7WrR16DPTt80Y5leRUVXPOtHeugs=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://github.com/linuxdeepin/dtkcore/commit/8f523a8b387a006b942268e2143d0d58c574f7c5.patch";
      hash = "sha256-x8BfWCdsz8Bf/sAM7PymZWqlPyEabwP0e6ybfz/2oZ4=";
    })
  ];

  postPatch = ''
    substituteInPlace misc/DtkCoreConfig.cmake.in \
      --subst-var-by PACKAGE_TOOL_INSTALL_DIR ${placeholder "out"}/libexec/dtk6/DCore/bin
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6Packages.qtbase
    lshw
    libuchardet
  ];

  propagatedBuildInputs = [
    dtkcommon
    dtk6log
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${finalAttrs.version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
    "-DDSG_PREFIX_PATH='/run/current-system/sw'"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DD_DSG_APP_DATA_FALLBACK=/var/dsg/appdata"
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
    for binary in $out/libexec/dtk6/DCore/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtk6core";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
})
