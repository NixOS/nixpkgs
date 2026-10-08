{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cg8qaOGAGRYPacbv4WswcEkQrNRSh5xtO5y6gsUW3x8=";
  };

  cargoHash = "sha256-c5cnkZD5XPpYab0JOF8L5h7U5GbvHBzLXH1jq4b5Y1w=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
