{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7OeGuZV8M/0/Hjn3gD+iEqsPmSNAgUK/Usf4eEXoNJ4=";
  };

  cargoHash = "sha256-7uMs6DSZVUFZh1UBzAtyqJhQjuUVen0O9Mx8vmbMedY=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = lib.licenses.gpl3;
  };
})
