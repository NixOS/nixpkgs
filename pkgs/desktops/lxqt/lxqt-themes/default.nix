{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1magzckhgrac2b5jm83hj3s8x4hyfnbh2v86lfa4c36whnfvsz29";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Themes, graphics and icons for LXQt";
    homepage = "https://github.com/lxqt/lxqt-themes";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
