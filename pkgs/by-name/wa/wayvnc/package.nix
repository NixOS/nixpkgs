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
  libdrm,
  libxkbcommon,
  libgbm,
  neatvnc,
  pam,
  pixman,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayvnc";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wayvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+CAH2jcIIQqImonWeWxMQyTtEEuuQlaGyl/ajPfClh8=";
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
    libdrm
    libxkbcommon
    libgbm
    neatvnc
    pam
    pixman
    wayland
  ];

  mesonFlags = [
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  __structuredAttrs = true;

  meta = {
    description = "VNC server for wlroots based Wayland compositors";
    longDescription = ''
      This is a VNC server for wlroots based Wayland compositors. It attaches
      to a running Wayland session, creates virtual input devices and exposes a
      single display via the RFB protocol. The Wayland session may be a
      headless one, so it is also possible to run wayvnc without a physical
      display attached.
    '';
    homepage = "https://github.com/any1/wayvnc";
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "wayvnc";
  };
})
