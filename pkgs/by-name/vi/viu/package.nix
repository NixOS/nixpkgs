{ lib
, rustPlatform
, fetchFromGitHub
, libsixel
, withSixel ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "sha256-sx8BH01vTFsAEnMKTcVZTDMHiVi230BVVGRexoBNxeo=";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoHash = "sha256-OyG4DAMoWdLBO0IOcbpD2Fmac0XIP7hdaeDdKiQ4PQA=";

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = with lib; {
    description = "Command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu sigmanificient ];
    mainProgram = "viu";
  };
}
