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
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-notificationd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "06gb8k1p24gm5axy42npq7n4lmsxb03a9kvzqby44qmgwh8pn069";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    qtx11extras
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "The LXQt notification daemon";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
