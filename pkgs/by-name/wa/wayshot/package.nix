{
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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sbY3h3FoWxDmxSng9YvYpt3kyasVJGsykYC/7tblFn8=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libgbm
    libjxl
    libGL
    wayland
  ];
  cargoHash = "sha256-J7ZKWx258bBCNBd061aCeKgTdcWMUF4yzAiIa9l8ZRA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      id3v1669
      Subserial
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
