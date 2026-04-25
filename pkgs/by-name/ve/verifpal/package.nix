{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k13pf7uWTuxeTAvY5Dw0WYA6PGa6uvsX537HLCHP2qE=";
  };

  cargoHash = "sha256-7aW3ppvtnqgmBtuwVkM1jPjtSRtB1dSjpogz0XfzKpM=";

  subPackages = [ "cmd/verifpal" ];

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
  };
})
