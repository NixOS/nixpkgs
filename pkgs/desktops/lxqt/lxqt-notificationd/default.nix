{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, qtx11extras
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-notificationd";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-Y3+ShGb1DKJw4zv3SCwEq2unJesI1q5OaTlSO8fP76A=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    qtx11extras
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "The LXQt notification daemon";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
