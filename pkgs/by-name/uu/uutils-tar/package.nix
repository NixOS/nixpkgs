{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "113912e981c979efb95b4112d218563fa0ef6329";
    hash = "sha256-ZNK3dpdJx4L8un35LQPZgtXiPC6hcOTFIJ26YKAqSNg=";
  };

  cargoHash = "sha256-cpYhIH6aYaWCcD8IA4iYuHMrcDCkLvkiwkwPc+UJw3g=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
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
