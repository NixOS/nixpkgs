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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1xi169gz1sarv7584kg33ymckqlx9ddci7r9m0dlm4a7mw7fm0lf";
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
    for f in lxqt-admin-{time,user}/CMakeLists.txt; do
      substituteInPlace $f --replace \
        "\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}" \
        "$out/share/polkit-1/actions"
    done
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-admin";
    description = "LXQt system administration tool";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
