{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libinput,
  libyaml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "way-displays";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = finalAttrs.version;
    hash = "sha256-OHIztOHxqkGuOCaNn/1w+qHSZAw7PrVOeXKRAsqJYTk=";
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
    libyaml
    libinput
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PREFIX_ETC=${placeholder "out"}"
    "CC:=$(CC)"
    "CXX:=$(CXX)"
  ];

  meta = {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ simoneruffini ];
    platforms = lib.platforms.linux;
    mainProgram = "way-displays";
  };
})
