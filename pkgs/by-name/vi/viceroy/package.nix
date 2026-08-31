{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viceroy";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7tX6wDGFsCkOPDIzM7fpZzUI2O6aLc6mM/5QIbNo0Tg=";
  };

  cargoHash = "sha256-kRk0mv89AG7pMxFR6OvVAq0pbOw5czq/PdD2KP6KJmw=";

  cargoTestFlags = [
    "--package"
    "viceroy-lib"
  ];

  meta = {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
    ];
    platforms = lib.platforms.unix;
  };
})
