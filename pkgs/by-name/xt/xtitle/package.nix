{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  xcbutil,
  xcbutilwm,
  git,
}:

stdenv.mkDerivation rec {
  pname = "xtitle";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "xtitle";
    rev = version;
    hash = "sha256-SVfM2vCCacgchXj0c0sPk3VR6DUI4R0ofFnxJSY4oDg=";
  };

  postPatch = ''
    sed -i "s|/usr/local|$out|" Makefile
  '';

  buildInputs = [
    libxcb
    git
    xcbutil
    xcbutilwm
  ];

  meta = with lib; {
    description = "Outputs X window titles";
    homepage = "https://github.com/baskerville/xtitle";
    maintainers = with maintainers; [ meisternu ];
    license = "Custom";
    platforms = platforms.linux;
    mainProgram = "xtitle";
  };
}
