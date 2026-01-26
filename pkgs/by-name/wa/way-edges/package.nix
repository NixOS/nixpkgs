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
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "way-edges";
    repo = "way-edges";
    tag = finalAttrs.version;
    hash = "sha256-1P4iOsoQolxfVGZEe+x0DvcDwB5bdBqR0OsfL+y3qQM=";
  };
  cargoHash = "sha256-RSCBQUZp6mxZcwsvr6OwQeXa5CmEhN8QUezv0By5j/s=";

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
