{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  libpulseaudio,
  cairo,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "way-edges";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "way-edges";
    repo = "way-edges";
    tag = finalAttrs.version;
    hash = "sha256-3EP+Arp2+K1zjdGaQgub67G+AgvoTLlRTSGgFTqMX9k=";
  };
  cargoHash = "sha256-E1MmCUBZSXkV0oEJ7vHiO2YawnTteu24h2+IVgB71fc=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    cairo
    libxkbcommon
    libpulseaudio
  ];

  env.RUSTFLAGS = toString [
    "--cfg tokio_unstable"
    "--cfg tokio_uring"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland client focusing on widgets hidden in your screen edge";
    homepage = "https://github.com/way-edges/way-edges";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ denperidge ];
    mainProgram = "way-edges";
    platforms = lib.platforms.linux;
  };
})
