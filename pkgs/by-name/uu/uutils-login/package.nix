{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "2ac4e1518bd743f45b89e8db146d77feb14da197";
    hash = "sha256-eQXEl4qWkn0X3EVL0Tj5VI2R092k7BKSyCJWClw1jxc=";
  };

  cargoHash = "sha256-zgKNU24HJFT/DISWflKNN9R88cioLxBNdL8eexCRAOE=";

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
