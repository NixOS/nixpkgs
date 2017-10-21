{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools,
  qtx11extras, qttools, qtsvg, libqtxdg, kwindowsystem, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liblxqt";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0dcsgj0qr4589wsibs6fdza4ncqavrhykd05d25rs78pa94lvvh5";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    libqtxdg
    xorg.libXScrnSaver
  ];

  cmakeFlags = [
    "-DPULL_TRANSLATIONS=NO"
    "-DLXQT_ETC_XDG_DIR=/run/current-system/sw/etc/xdg"
  ];
  
  patchPhase = ''
    sed -i 's|set(LXQT_SHARE_DIR .*)|set(LXQT_SHARE_DIR "/run/current-system/sw/share/lxqt")|' CMakeLists.txt
  '';
  
  meta = with stdenv.lib; {
    description = "Core utility library for all LXQt components";
    homepage = https://github.com/lxde/liblxqt;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
