{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "c1a70e6c2f8125076c69a7eed7b0c267731ef00e";
    hash = "sha256-eW8edhGeE3XnPq59kl2tz78QEu8SBsUKGbjU8vYEOSs=";
  };

  cargoHash = "sha256-h1judrTw9/r3iHRU3ndnJvx4ksHNCNHh67XpRDV1QkA=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplemtation of the login project";
    homepage = "https://github.com/uutils/login";
    license = lib.licenses.mit;
    mainProgram = "shadow";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
