{
  egl-wayland,
  lib,
  libgbm,
  libjxl,
  libGL,
  fetchFromGitHub,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayshot";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xw3UN0linKp0jcAYYE0eX7x/bQ97gIQPDCIY9tlEhN4=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    egl-wayland
    pango
    libgbm
    libjxl
    libGL
    wayland
  ];
  cargoHash = "sha256-z5cqpC+Yt0PsEj9iab+7buO+OudbtzNYJulEUE10eZY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      dit7ya
      id3v1669
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
