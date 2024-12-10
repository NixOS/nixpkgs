{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  glibmm,
  doxygen,
  qttools,
  qtbase,
  buildDocs ? true,
}:

stdenv.mkDerivation rec {
  pname = "gio-qt";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-/wLaVR31T+EcT6D5Cw0QIjZasioPWC74KNmt1tckwXk=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
      wrapQtAppsHook
    ]
    ++ lib.optionals buildDocs [
      doxygen
      qttools.dev
    ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPROJECT_VERSION=${version}"
  ] ++ lib.optionals (!buildDocs) [ "-DBUILD_DOCS=OFF" ];

  propagatedBuildInputs = [ glibmm ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Gio wrapper for Qt applications";
    homepage = "https://github.com/linuxdeepin/gio-qt";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
