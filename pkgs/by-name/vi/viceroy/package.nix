{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
    hash = "sha256-DeViAqL+7mta/wH7rLyltOCtHCTFXZczn2vAL1k+R2Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LBJD1w8/jLw5xYdHxR+EM2Cb4eVFpRw+M/K7K4Z0OUw=";

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
