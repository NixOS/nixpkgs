{ lib, buildDunePackage, fetchFromGitHub, pkg-config, dune-configurator, lame }:

buildDunePackage rec {
  pname = "lame";
<<<<<<< HEAD
  version = "0.3.7";
=======
  version = "0.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lame";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-/ZzoGFQQrBf17TaBPSFDQ1yHaQnva56YLmscOacrKBI=";
=======
    sha256 = "sha256-oRxP1OM0pGdz8CB+ou7kbbrNaB1x9z9KTfciLsivFnI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ lame ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lame";
    description = "Bindings for the lame library which provides functions for encoding mp3 files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
