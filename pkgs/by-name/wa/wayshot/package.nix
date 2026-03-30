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
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RaOe00+Dy+zgdEkfF5hJrJ/lSA2vrsZWVoDsTc3uwpw=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libgbm
    libjxl
    libGL
    wayland
  ];
  cargoHash = "sha256-zuRl0WxS9MyyRsCpbFlVKN+5FasIbfkXutaM3Gmic04=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      dit7ya
      id3v1669
      Subserial
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
