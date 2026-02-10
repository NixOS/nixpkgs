{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "d79af67c4bc7b431de0e0c7058af2602396f6e39";
    hash = "sha256-KjVt3KE0OdX8bBqFxd2B48Vf0nrg5jKix2JkjazU0+c=";
  };

  cargoHash = "sha256-PYux+7DU0LS0ugLKKr1S65XMmugZyK+FlWJkWKd+C4w=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the hostname project";
    homepage = "https://github.com/uutils/hostname";
    license = lib.licenses.mit;
    mainProgram = "hostname";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
