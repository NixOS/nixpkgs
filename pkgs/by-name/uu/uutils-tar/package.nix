{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "3236dd7b87413b10b9bcd650c731f0b0677671fb";
    hash = "sha256-WGqZEAbcMykYlLdoMqdUVuc7EpA77nGqAKgzl2vDbws=";
  };

  cargoHash = "sha256-EavcBmhOhUUD0pla50tgNJw7z2jDgxTUvIZuZYa58KQ=";

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
