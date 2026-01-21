{
  lib,
  zig,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  wlr-protocols,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsnow";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "DarkVanityOfLight";
    repo = "ZSnoW";
    rev = "db8491639e45dbb925652512cb5941f1ea1a1ec2";
    hash = "sha256-h9o/6X2WPfeJrLIx3WnVo0l4i80zHnmO2KkYuVJY2Sk=";
  };
  zigWayland = fetchFromGitHub {
    owner = "ifreund";
    repo = "zig-wayland";
    tag = "v0.4.0";
    hash = "sha256-ulIII5iJpM/W/VJB0HcdktEO2eb9T9J0ln2A1Z94dU4=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
  ];

  postPatch = ''
    ln -s ${finalAttrs.zigWayland} ./zig-wayland

    substituteInPlace build.zig \
      --replace-fail \
        'scanner.addCustomProtocol(.{ .cwd_relative = "/usr/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml" });' \
        'scanner.addCustomProtocol(.{ .cwd_relative = "${wlr-protocols}/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml" });'

    substituteInPlace build.zig.zon \
      --replace-fail \
        '.url = "https://github.com/ifreund/zig-wayland/archive/refs/tags/v0.4.0.zip",' \
        '.path = "./zig-wayland",' \
      --replace-fail \
        '.hash = "wayland-0.4.0-lQa1khbMAQAsLS2eBR7M5lofyEGPIbu2iFDmoz8lPC27",' \
        ""
  '';

  # no tests
  dontUseZigCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XSnow for Wayland";
    homepage = "https://github.com/DarkVanityOfLight/ZSnoW";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = [ lib.maintainers.koi ];
    platforms = lib.platforms.linux;
    mainProgram = "zsnow";
  };
})
