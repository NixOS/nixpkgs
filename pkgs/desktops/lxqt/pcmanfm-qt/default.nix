{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt, qtbase, qttools,
  qtx11extras, libfm-qt, menu-cache, lxmenu-data }:

stdenv.mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1zchxlbyiifing94mqwh45pp7z3ihldknqiaz0kanq1cnma1jj6k";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    libfm-qt
    libfm-qt
    menu-cache
    lxmenu-data
  ];

  postPatch = ''
    for dir in autostart config; do
      substituteInPlace $dir/CMakeLists.txt \
        --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
    done
  '';

  meta = with stdenv.lib; {
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = https://github.com/lxqt/pcmanfm-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
