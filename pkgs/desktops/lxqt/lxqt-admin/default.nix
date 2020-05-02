{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtx11extras
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, polkit-qt
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-admin";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "16fbnlvla8lq6rkv5gpmkw2jj9h1wzd3jcf8sjrbns6ygyfdxx3a";
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "LXQt system administration tool";
    homepage = "https://github.com/lxqt/lxqt-admin";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
