{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-djUBSplEHIGEk1ofaHtfzXJ1HCztrXtZoS30goY1w5A=";
  };

  cargoHash = "sha256-D6VSmQOwdKWUSsxPr/6hq0SjE1LYusn9HZsNi07cGSk=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ereslibre
    ];
    platforms = platforms.unix;
  };
}
