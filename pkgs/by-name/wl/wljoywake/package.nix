{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

let
  version = "0.3";
in
stdenv.mkDerivation {
  pname = "wljoywake";
  inherit version;

  src = fetchFromGitHub {
    repo = "wljoywake";
    owner = "nowrep";
    rev = "v${version}";
    hash = "sha256-zSYNfsFjswaSXZPlIDMDC87NK/6AKtArHBeWCWDDR3E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    udev
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Wayland tool for idle inhibit when using joysticks";
    homepage = "https://github.com/nowrep/wljoywake";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jtrees ];
    mainProgram = "wljoywake";
  };
}
