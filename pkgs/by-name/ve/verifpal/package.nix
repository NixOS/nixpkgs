{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "0.80.1";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C5k9vXd91m7AZWqSCTw4qxD3onuq/1bMhlIia9XW2II=";
  };

  cargoHash = "sha256-7qfKG7iUcoKOcyFfDgaCDiXF3eAOO/wGJgu7XocSXZU=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
