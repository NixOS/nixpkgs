{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, doxygen
, qt6Packages
, lshw
, libuchardet
, spdlog
, dtkcommon
, systemd
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6core";
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6core";
    rev = finalAttrs.version;
    hash = "sha256-zUJFilafR0hNH/Owmuyh6BLBFPbBuFKcHv40fena0GM=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
    (fetchpatch {
      name = "fix-build-on-qt-6_7_1.patch";
      url = "https://github.com/linuxdeepin/dtkcore/commit/10bd3842bbde41fbc61c35b81d280075d053119b.patch";
      hash = "sha256-xZ3BhiMB6S5NJtPUEjtChCB9Jr1BI0mu7AMjyNMqt9w=";
    })
  ];

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
    spdlog
  ]
  ++ lib.optional withSystemd systemd;

  propagatedBuildInputs = [ dtkcommon ];

  cmakeFlags = [
    "-DDTK_VERSION=${finalAttrs.version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
    "-DDSG_PREFIX_PATH='/run/current-system/sw'"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DD_DSG_APP_DATA_FALLBACK=/var/dsg/appdata"
    "-DBUILD_WITH_SYSTEMD=${if withSystemd then "ON" else "OFF"}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${lib.getBin qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

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
    maintainers = lib.teams.deepin.members;
  };
})
