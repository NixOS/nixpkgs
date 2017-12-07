{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, qtx11extras }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-notificationd";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0pmpdqgnb2dfxw5lirh89j8hnrwwcn2zc64byg4zi0xdvq6qms43";
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
    homepage = https://github.com/lxde/lxqt-notificationd;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
