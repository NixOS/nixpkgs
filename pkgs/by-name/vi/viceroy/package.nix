{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-rK+Us4QvvWpHtMvq5s3koPyy7xKhVQsxUMQnpyfMtDU=";
  };

  cargoHash = "sha256-SacepQEMpDxqd7vl/sjkxyTb3R7z+Q1IQOrfZyV8nRU=";

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
