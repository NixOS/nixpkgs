{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5h2EFC8+eDjvG0p9qnVlFe8wzDGPjp8ALKdr6fLodrg=";
  };

  cargoHash = "sha256-290oRORl2ju3m/GPhS+im4WL1cWc85RVr/8owYfC1sU=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
