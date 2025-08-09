{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-DHA0nfTDq40qoNnD9ZgLtouKEzi9jFUCowMCoBdnqNU=";
  };

  cargoHash = "sha256-f4F6MNJaLJiwY7ZkqrbrDXGufrb/aO3WgMmE7gRGvdQ=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ereslibre
      shyim
    ];
    platforms = platforms.unix;
  };
}
