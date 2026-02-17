{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viceroy";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KeFKh8ZAUJXBUo0MRw/jU0HnBrehX0YkvbvMUX8ovcA=";
  };

  cargoHash = "sha256-PoexldRTp2cPu7iF7te//kO4Ph1P6A/jNZdMkYKERqM=";

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
