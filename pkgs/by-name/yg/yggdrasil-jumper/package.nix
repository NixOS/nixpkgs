{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yggdrasil-jumper";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "one-d-wide";
    repo = "yggdrasil-jumper";
    rev = "v${version}";
    hash = "sha256-Op3KBJ911AjB7BIJuV4xR8KHMxBtQj7hf++tC1g7SlM=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reduce latency of a connection over yggdrasil network";
    homepage = "https://github.com/one-d-wide/yggdrasil-jumper";
    changelog = "https://github.com/one-d-wide/yggdrasil-jumper/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.all;
    mainProgram = "yggdrasil-jumper";
  };
}
