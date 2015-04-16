{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-qtplugin";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "f1a07120b6d74068c5d3a14babbd5d05f44d2750";
    sha256 = "a8aaca118699ef81573fc13a59d8ba0ea829b544b466755aaab9f74b188d9b67";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    liblxqt libqtxdg
  ];

  # Need to override the QT_PLUGINS_DIR variable from qt5
  patchPhase = ''
    PATTERN=\$\{QT_PLUGINS_DIR}
    substituteInPlace src/CMakeLists.txt --replace "$PATTERN" $out/lib/qt5/plugins
  '' + standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "LxQt platform integration plugin for Qt5 (let all Qt programs apply LxQt settings)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
