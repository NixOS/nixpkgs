{ stdenv, fetchgit
, cmake
, qt54
, kwindowsystem
, libqtxdg
}:

stdenv.mkDerivation rec {
  basename = "liblxqt";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "64d1e6c1076aea2783138e9d5ce4bb30b58c77b4";
    sha256 = "940e505ba9c7693770224aa16e64bbb805736b946bbaa25e8180528d3681359d";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools qt54.x11extras kwindowsystem libqtxdg ];

  patchPhase = ''
    sed -i 's|DESTINATION ..TR_INSTALL_DIR.|DESTINATION share/lxqt/translations|' cmake/modules/LXQtTranslateTs.cmake
    sed -i 's|set(LXQT_SHARE_DIR .*)|set(LXQT_SHARE_DIR "/run/current-system/sw/share/lxqt")|' CMakeLists.txt
  '';

  preConfigure = ''
    cmakeFlags="-DLXQT_ETC_XDG_DIR=/run/current-system/sw/etc/xdg"
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Common base library for most lxde-qt components";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
