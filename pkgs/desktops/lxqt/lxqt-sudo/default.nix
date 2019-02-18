{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg, sudo }:

stdenv.mkDerivation rec {
  pname = "lxqt-sudo";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0l8fq06kfsrmvg2fr8lqdsxr6fwxmxsa9zwaa3fs9inzaylm0jkh";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    sudo
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
  '';

  meta = with stdenv.lib; {
    description = "GUI frontend for sudo/su";
    homepage = https://github.com/lxqt/lxqt-sudo;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
