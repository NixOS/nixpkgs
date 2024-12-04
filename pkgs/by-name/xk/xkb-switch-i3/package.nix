{ lib, stdenv
, cmake
, fetchFromGitHub
, i3
, jsoncpp
, libsigcxx
, libX11
, libxkbfile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "xkb-switch-i3";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Zebradil";
    repo = "xkb-switch-i3";
    rev = version;
    hash = "sha256-5d1DdRtz0QCWISSsWQt9xgTOekYUCkhfMsjG+/kyQK4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ i3 jsoncpp libsigcxx libX11 libxkbfile ];

  meta = with lib; {
    description = "Switch your X keyboard layouts from the command line(i3 edition)";
    homepage = "https://github.com/Zebradil/xkb-switch-i3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
    mainProgram = "xkb-switch";
  };
}
