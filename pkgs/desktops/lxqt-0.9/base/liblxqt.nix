{ stdenv, fetchFromGitHub
, cmake
, qt54
, kwindowsystem
, libqtxdg
}:

stdenv.mkDerivation rec {
  basename = "liblxqt";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = basename;
    rev = version;
    sha256 = "00smn3a32gmzhhl3j884659sw0wkcm618q899633k5m1kw5dlb3y";
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
