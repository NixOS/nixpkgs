{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libinput,
  yaml-cpp,
}:

stdenv.mkDerivation rec {
  pname = "way-displays";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = version;
    sha256 = "sha256-IW9LolTZaPn2W8IZ166RebQRIug0CyFz/Prgr34wNwM=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    yaml-cpp
    libinput
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PREFIX_ETC=${placeholder "out"}"
    "CC:=$(CC)"
    "CXX:=$(CXX)"
  ];

  meta = with lib; {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = licenses.mit;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
    mainProgram = "way-displays";
  };
}
