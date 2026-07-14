{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-07-02";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "70c59758d0eeb65c097a95df49e455448061ccbc";
    hash = "sha256-PMsW+p7ps/6eRNuSbzxIDVEgTmHAh0vFjVqSelAfvVE=";
  };

  cargoHash = "sha256-YBpXvD8hhjlxZHRDv6hsRqqD0Wm8ADDdgOrX1/yziL8=";

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
