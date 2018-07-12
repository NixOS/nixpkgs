{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools,
  polkit-qt, qtx11extras, qttools, qtsvg, libqtxdg, kwindowsystem, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liblxqt";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1lbvnx6gg15k7fy1bnv5sjji659f603glblcl8c9psh0m1cjdbll";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    polkit-qt
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
    sed "s,\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR},''${out}/share/polkit-1/actions," \
        -i CMakeLists.txt
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
