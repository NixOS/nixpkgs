{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viceroy";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8tQtDjw4+A+2e6LRaJtATpnaWa+kaD/9VU5lAW82U0k=";
  };

  cargoHash = "sha256-+ZNvZwcHpez+3eOhsRNwTj3SariGAZhFL1i72Wn1CJ8=";

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
