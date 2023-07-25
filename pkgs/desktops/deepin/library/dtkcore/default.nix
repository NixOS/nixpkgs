{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, doxygen
, wrapQtAppsHook
, qtbase
, gsettings-qt
, lshw
, libuchardet
, dtkcommon
, systemd
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  pname = "dtkcore";
  version = "5.6.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-ge8DiJMSaZo7GeQEgnDbi5SLsLxtOQ/P5/9aBgaG7Ds=";
  };

  postPatch = ''
    substituteInPlace src/dsysinfo.cpp \
      --replace "/usr/share/deepin/distribution.info" "/etc/distribution.info" \
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    doxygen
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    gsettings-qt
    lshw
    libuchardet
  ]
  ++ lib.optional withSystemd systemd;

  propagatedBuildInputs = [ dtkcommon ];

  cmakeFlags = [
    "-DDVERSION=${version}"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_DOCS=ON"
    "-DQCH_INSTALL_DESTINATION=${qtbase.qtDocPrefix}"
    "-DDSG_PREFIX_PATH='/run/current-system/sw'"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DD_DSG_APP_DATA_FALLBACK=/var/dsg/appdata"
    "-DBUILD_WITH_SYSTEMD=${if withSystemd then "ON" else "OFF"}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtkcore";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
