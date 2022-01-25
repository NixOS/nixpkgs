{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1viaqmcq4axwsq5vrr08j95swapbqnwmv064kaijm1jj9csadsvv";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
