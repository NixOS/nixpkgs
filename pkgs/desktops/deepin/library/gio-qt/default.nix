{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  glibmm,
  doxygen,
  buildDocs ? true,
}:

stdenv.mkDerivation rec {
  pname = "gio-qt";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-qDkkLqGsrw+otUy3/iZJJZ2RtpNYPGc/wktdVpw2weg=";
  };

  # Upstream compiles both qt5 and qt6 versions, which is not possible in nixpkgs
  # because of the conflict between qt5 hooks and qt6 hooks
  postPatch = ''
    substituteInPlace {gio-qt,qgio-tools}/CMakeLists.txt \
      --replace "include(qt6.cmake)" " "
  '';

  nativeBuildInputs =
    [
      cmake
      pkg-config
      libsForQt5.wrapQtAppsHook
    ]
    ++ lib.optionals buildDocs [
      doxygen
      libsForQt5.qttools
    ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPROJECT_VERSION=${version}"
  ] ++ lib.optionals (!buildDocs) [ "-DBUILD_DOCS=OFF" ];

  propagatedBuildInputs = [ glibmm ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Gio wrapper for Qt applications";
    homepage = "https://github.com/linuxdeepin/gio-qt";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
