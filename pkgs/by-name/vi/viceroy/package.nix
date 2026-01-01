{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
<<<<<<< HEAD
  version = "0.16.2";
=======
  version = "0.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7IIgFoRYRQ7O6VS4C80CIzmtZOQypdZO8BEdMhO4u8o=";
  };

  cargoHash = "sha256-04+sZm43YZXpkVdFuoI2ej7Gt7CG52hOdp52x3AgFzg=";
=======
    hash = "sha256-qDPQObPnSPmqR5JkZHP3VPEN025T4ZAtuXNqAbsTyW8=";
  };

  cargoHash = "sha256-+xDzLTtp44GJaoNFmef0twviAPsP35B2X7l25NVAIBg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

<<<<<<< HEAD
  meta = {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ereslibre
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
