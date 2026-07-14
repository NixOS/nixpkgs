{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-07-09";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "d1e56e3cf1f450e5add1b24785dd654e4b745b18";
    hash = "sha256-LnDTnzAxRNrDmf/vns6xqPEEYC5PrlT4dC8nfSPU2Kc=";
  };

  cargoHash = "sha256-FobHV37gdez4GQf6MToYfd4cJufroygP+ge37eFtsmc=";

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
