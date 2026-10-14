{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viceroy";
  version = "0.21.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vwoJ7PixrO68vUSo+u10wFdeD0TU2cISNWcNJ4qLTB8=";
  };

  cargoHash = "sha256-dkoKFEeM6DI6Iaypgexa18YjoLySnIX1YfUItySx1Q0=";

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
      stepbrobd
    ];
    platforms = lib.platforms.unix;
  };
})
