{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, polkit-qt }:

mkDerivation rec {
  pname = "lxqt-admin";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "121qj46app2bqdr24g5sz2mdjfd9w86wpgkwap46s0zgxm4li44i";
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
    liblxqt
    libqtxdg
    polkit-qt
  ];

  postPatch = ''
    sed "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" \
      -i lxqt-admin-user/CMakeLists.txt
  '';

  meta = with lib; {
    description = "LXQt system administration tool";
    homepage = https://github.com/lxqt/lxqt-admin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
