{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras,
  qttools, qtsvg, libqtxdg, polkit-qt, kwindowsystem, xorg }:

mkDerivation rec {
  pname = "liblxqt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0g2502lcws5j74p82qhfryz9n51cvi85hb50r5s227xhkv91q65k";
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

  postPatch = ''
    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" CMakeLists.txt
  '';

  meta = with lib; {
    description = "Core utility library for all LXQt components";
    homepage = https://github.com/lxqt/liblxqt;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
