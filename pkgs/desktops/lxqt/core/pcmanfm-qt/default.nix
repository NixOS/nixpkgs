{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, lxqt, libfm, menu-cache, lxmenu-data }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pcmanfm-qt";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "050h5w1wph35l5m69qbxzvc96y7y0bg1m7flqdadrp688pbnzcxb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    lxqt.libfm-qt
    libfm
    menu-cache
    lxmenu-data
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    for dir in autostart config; do
      substituteInPlace $dir/CMakeLists.txt \
        --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
    done
  '';

  meta = with stdenv.lib; {
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = https://github.com/lxde/pcmanfm-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
