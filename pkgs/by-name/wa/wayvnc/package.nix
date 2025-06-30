{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  aml,
  jansson,
  libxkbcommon,
  libgbm,
  neatvnc,
  pam,
  pixman,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wayvnc";
    rev = "v${version}";
    hash = "sha256-LINzkC18gitj1a8Giqlt/6LyydOdV+8YXRJmuxT/Nq8=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    aml
    jansson
    libxkbcommon
    libgbm
    neatvnc
    pam
    pixman
    wayland
  ];

  mesonFlags = [
    (lib.mesonBool "tests" true)
  ];

  doCheck = true;

  meta = {
    description = "VNC server for wlroots based Wayland compositors";
    longDescription = ''
      This is a VNC server for wlroots based Wayland compositors. It attaches
      to a running Wayland session, creates virtual input devices and exposes a
      single display via the RFB protocol. The Wayland session may be a
      headless one, so it is also possible to run wayvnc without a physical
      display attached.
    '';
    mainProgram = "wayvnc";
    inherit (src.meta) homepage;
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
