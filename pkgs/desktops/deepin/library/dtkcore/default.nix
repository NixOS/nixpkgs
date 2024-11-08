{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  doxygen,
  libsForQt5,
  gsettings-qt,
  lshw,
  libuchardet,
  dtkcommon,
  dtklog,
}:

stdenv.mkDerivation rec {
  pname = "dtkcore";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-APuBVgewr701wzfTRwaQIg/ERFIhabEs5Jd6+GvD04k=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  postPatch = ''
    substituteInPlace misc/DtkCoreConfig.cmake.in \
      --subst-var-by PACKAGE_TOOL_INSTALL_DIR ${placeholder "out"}/libexec/dtk5/DCore/bin
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libsForQt5.qtbase
    gsettings-qt
    lshw
    libuchardet
  ];

  propagatedBuildInputs = [
    dtkcommon
    dtklog
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${libsForQt5.qtbase.qtDocPrefix}"
    "-DDSG_PREFIX_PATH='/run/current-system/sw'"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DTOOL_INSTALL_DIR=${placeholder "out"}/libexec/dtk5/DCore/bin"
    "-DD_DSG_APP_DATA_FALLBACK=/var/dsg/appdata"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postFixup = ''
    for binary in $out/libexec/dtk5/DCore/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = with lib; {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtkcore";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
