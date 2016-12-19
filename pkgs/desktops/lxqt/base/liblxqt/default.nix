{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liblxqt";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "12gla3pdg0n28w15qrmha83xm3021xdby8ydwp1qzcips5pa5zac";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.libqtxdg
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
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
