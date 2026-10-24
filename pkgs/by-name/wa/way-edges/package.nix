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
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "way-edges";
    repo = "way-edges";
    tag = finalAttrs.version;
    hash = "sha256-DT1235dt5XeLLvIj6sDafTt0/5mCfJQ1zBr1Ii0O580=";
  };
  cargoHash = "sha256-TswMHWiBVqkb/zz/ZvP9Ipo5cRq6768VskF539Xk7Js=";

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
