{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools,
  qtx11extras, qttools, qtsvg, libqtxdg, kwindowsystem, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liblxqt";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1852vfbkbpw49i8ad682jhqmnskmc9a90qwpalipgak7m64azg3j";
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
