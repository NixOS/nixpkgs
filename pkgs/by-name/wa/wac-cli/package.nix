{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  name = "wac-cli";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VJq7xWTQcvXSzwCqdU53GNAk778f/Xp0IAomsD3c8pQ=";
  };

  cargoHash = "sha256-connilUNS+BKdVXDPCSA+QY/DY3wVt+SzxGAto8eeZE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly Composition (WAC) tooling";
    license = lib.licenses.asl20;
    homepage = "https://github.com/bytecodealliance/wac";
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wac";
  };
})
