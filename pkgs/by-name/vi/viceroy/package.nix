{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-7IIgFoRYRQ7O6VS4C80CIzmtZOQypdZO8BEdMhO4u8o=";
  };

  cargoHash = "sha256-04+sZm43YZXpkVdFuoI2ej7Gt7CG52hOdp52x3AgFzg=";

  cargoTestFlags = [
    "--package viceroy-lib"
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
}
