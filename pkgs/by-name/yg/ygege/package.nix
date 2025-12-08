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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "UwUDev";
    repo = "ygege";
    tag = "v${finalAttrs.version}";
    hash = "sha256-09pQOCACcwCW2UZY5SJJ9SnVTkUd4eU32ug0/Wov658=";
  };

  cargoHash = "sha256-vigCAb2hsMnjuZNKh8PHQ4VaLI6F3lQeJm/+esQZ6oc=";

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
