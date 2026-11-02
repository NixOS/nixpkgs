{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "8bb814d16a21a2f5e7a273ff08763efc993f9ed4";
    hash = "sha256-3C8aAAz2orkYyDBa778bSPwSJ6MEvcUPP2ORhyh1B+A=";
  };

  cargoHash = "sha256-8kLLuHQ5jCdMgiCjAi74myCZ6QD/25k1woLggxpA2eE=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^(?!latest-commit.*)(.*)$"
    ];
  };

  meta = {
    description = "Rust implementation of tar";
    homepage = "https://github.com/uutils/tar";
    license = lib.licenses.mit;
    mainProgram = "tarapp";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
