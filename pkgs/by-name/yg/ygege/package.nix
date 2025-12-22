{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ygege";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "UwUDev";
    repo = "ygege";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t2soH/5R3lZus2iekxDi0Z65gufni8p+R/4DxQVAqok=";
  };

  cargoHash = "sha256-TYvySTg1kgvB7czLxLjSpFDKXcaiowaIxwCCMn9MJ+U=";

  nativeBuildInputs = [
    cmake
    pkg-config
    git
    rustPlatform.bindgenHook
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance indexer for YGG Torrent";
    homepage = "https://github.com/UwUDev/ygege";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
    mainProgram = "ygege";
  };
})
