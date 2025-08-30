{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-tfIUmyQjoWflAjA4aOIJ7xhUgVG5Njf54W36h8a1vQ8=";
  };

  cargoHash = "sha256-0xrT1Eum0ttApkN09U4MEo/vM6y6t6+e7iVcuih2b5U=";

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
