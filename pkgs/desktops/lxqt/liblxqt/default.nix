{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras,
  qttools, qtsvg, libqtxdg, polkit-qt, kwindowsystem, xorg }:

stdenv.mkDerivation rec {
  pname = "liblxqt";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1cpl6sd2fifpflahm8fvrrscrv03sinfm03m7yc1k59y6nsbwi36";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    polkit-qt
    kwindowsystem
    libqtxdg
    xorg.libXScrnSaver
  ];

  cmakeFlags = [
    "-DLXQT_ETC_XDG_DIR=/run/current-system/sw/etc/xdg"
  ];

  postPatch = ''
    sed -i 's|set(LXQT_SHARE_DIR .*)|set(LXQT_SHARE_DIR "/run/current-system/sw/share/lxqt")|' CMakeLists.txt
    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" CMakeLists.txt
    substituteInPlace CMakeLists.txt \
      --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
  '';

  meta = with stdenv.lib; {
    description = "Core utility library for all LXQt components";
    homepage = https://github.com/lxqt/liblxqt;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
