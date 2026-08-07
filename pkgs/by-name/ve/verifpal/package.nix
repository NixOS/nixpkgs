{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8WOEGE/bvZ1eKOMPXdg2R+ESsYYld1BiDBNk3KrQJuU=";
  };

  cargoHash = "sha256-kDskJRb5mGn0BoMAaw24twlexkSJavei7ncRZXDujvk=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
