{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, libogg }:

buildDunePackage rec {
  pname = "ogg";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ogg";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-S6rJw90c//a9d63weCLuOBoQwNqbpTb+lRytvHUOZuc=";
=======
    sha256 = "sha256-D6tLKBSGfWBoMfQrWmamd8jo2AOphJV9xeSm+l06L5c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ogg";
    description = "Bindings to libogg";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
