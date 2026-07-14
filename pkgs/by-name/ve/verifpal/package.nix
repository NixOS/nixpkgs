{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verifpal";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o59Pn5B1GW8fzSsUzaJaK1S/CWaYLLVpqIcQ0L5P1KA=";
  };

  cargoHash = "sha256-BvaCEqxdY16oHb2jHsqu6mL4ZNtIhY4S+OnrqQ80Yhc=";

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
  };
})
