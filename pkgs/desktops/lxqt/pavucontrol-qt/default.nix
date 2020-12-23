{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt
, libpulseaudio
, pcre
, qtbase
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1d3kp2y3crrmbqak4mn9d6cfbhi5l5xhchhjh44ng8gpww22k5h0";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    libpulseaudio
    pcre
  ];

  passthru.updateScript = lxqt.lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ romildo ];
  };
}
