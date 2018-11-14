{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, qtx11extras }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-notificationd";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0vjpl3ipc0hrz255snkp99h6xrlid490ml8jb588rdpfina66sp1";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  postPatch = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
  '';

  buildInputs = [
    qtbase
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    qtx11extras
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The LXQt notification daemon";
    homepage = https://github.com/lxqt/lxqt-notificationd;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
