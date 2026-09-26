{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elm-json";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "zwilias";
    repo = "elm-json";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pSt4ugP8r7s0ABT3Y9ZbWAG/ShsARtame2lTxXiCuws=";
  };

  cargoPatches = [ ./use-system-ssl.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-BnL//AHaSnsugtMEnSTynpMyeNt5N7L6PG2wdWDw1y4=";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = {
    description = "Install, upgrade and uninstall Elm dependencies";
    mainProgram = "elm-json";
    homepage = "https://github.com/zwilias/elm-json";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.turbomack ];
  };
})
