{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtx11extras
, qttools
, qtsvg
, libqtxdg
, polkit-qt
, kwindowsystem
, xorg
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "liblxqt";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1dqxsz8fy6xyzbkxhsymmr71yw4d5dwjgqd4rdjn0r9gk8ajrfzp";
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Core utility library for all LXQt components";
    homepage = "https://github.com/lxqt/liblxqt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
