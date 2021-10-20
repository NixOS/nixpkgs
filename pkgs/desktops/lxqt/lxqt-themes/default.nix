{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "13zh5yrq0f96cn5m6i7zdvgb9iw656fad5ps0s2zx6x8mj2mv64f";
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
