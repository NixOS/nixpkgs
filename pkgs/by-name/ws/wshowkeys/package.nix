{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  wayland-scanner,
  ninja,
  cairo,
  libinput,
  pango,
  wayland,
  wayland-protocols,
  libxkbcommon,
}:

stdenv.mkDerivation {
  pname = "wshowkeys-unstable";
  version = "2021-08-01";

  src = fetchFromGitHub {
    owner = "repparw";
    repo = "wshowkeys";
    rev = "27cedb85628051969ea6a96bf83d95d80c0c8955";
    hash = "sha256-+CWHCajznhOq27CdV7QRknluy76faswbdngS26z87Ww=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    pkg-config
    wayland-scanner
    ninja
  ];
  buildInputs = [
    cairo
    libinput
    pango
    wayland
    wayland-protocols
    libxkbcommon
  ];

  meta = {
    description = "Displays keys being pressed on a Wayland session";
    longDescription = ''
      Displays keypresses on screen on supported Wayland compositors (requires
      wlr_layer_shell_v1 support).
      Note: This tool requires root permissions to read input events, but these
      permissions are dropped after startup. The NixOS module provides such a
      setuid binary (use "programs.wshowkeys.enable = true;").
    '';
    homepage = "https://github.com/repparw/wshowkeys";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    # Some portions of the code are taken from Sway which is MIT licensed.
    # TODO: gpl3Only or gpl3Plus (ask upstream)?
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      berbiche
      repparw
    ];
    mainProgram = "wshowkeys";
  };
}
