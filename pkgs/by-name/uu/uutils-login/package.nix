{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "0f5fc5f66a890b65381dfaa3f112e2879476ad38";
    hash = "sha256-Vkivr/lBj+kNiJji/wFKvsfvmD+vv9CxkPio1ZWolOE=";
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
