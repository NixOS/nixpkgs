{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qpBmIxj66FIATFUnlIZclNEromsgJdlnvqpjPl9R8p8=";
  };

  cargoHash = "sha256-oskc2IaNvnGmpsZRQa59rstU3eEilaGDXbOQxpv0JKY=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
