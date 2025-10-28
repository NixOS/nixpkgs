{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-CG+D4jh5p6bcc0E6qTvecwkoxCRoHJAGiAOtR8A+Otc=";
  };

  cargoHash = "sha256-K4nh/ODbk++UxxIoeLpq4boWGbID2DJW845rx605Z7Y=";

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
