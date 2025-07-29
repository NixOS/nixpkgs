{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  meson,
  rustc,
  cargo,
  ninja,
  xdg-desktop-portal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6D21Dwpi7Zrf6Whxy41RwdKLLHmevP2M9pgdnz7mgE0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-j5M8rKKq2pdHHUQyGf1EZZWj5dpw4RnKxKEbzfT7coc=";
  };

  nativeBuildInputs = [
    meson
    rustc
    rustPlatform.cargoSetupHook
    cargo
    ninja
  ];

  buildInputs = [
    xdg-desktop-portal
  ];

  meta = {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      samuelefacenda
      Rishik-Y
      Gliczy
    ];
  };
})
