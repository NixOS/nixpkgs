{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  withSixel ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "viu";
<<<<<<< HEAD
  version = "1.6.1";
=======
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+6oo6cJ0L3XuMWZL/8DEKMk6PI7D5IcfoemqIQiOJto=";
=======
    hash = "sha256-sx8BH01vTFsAEnMKTcVZTDMHiVi230BVVGRexoBNxeo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # tests need an interactive terminal
  doCheck = false;

<<<<<<< HEAD
  cargoHash = "sha256-gqMG3ATyGTx54Q43Hquc8A/H8fhdgVP1JLh5FGtWTTU=";
=======
  cargoHash = "sha256-a9Z6/+/fMyJ2pFiKPexuiM5DAbk+Tcq3D9rDAyUwC84=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = {
    description = "Command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chuangzhu
      sigmanificient
    ];
    mainProgram = "viu";
  };
}
