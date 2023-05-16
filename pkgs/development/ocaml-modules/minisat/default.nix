{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "minisat";
<<<<<<< HEAD
  version = "0.5";

  minimalOCamlVersion = "4.05";
=======
  version = "0.4";

  useDune2 = true;

  minimumOCamlVersion = "4.05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "c-cube";
    repo   = "ocaml-minisat";
    rev    = "v${version}";
<<<<<<< HEAD
    hash   = "sha256-hqGSHxhT+Z2slRCIXnfYuasG1K3tVG/tsM0IXxmy9hQ=";
=======
    sha256 = "009jncrvnl9synxx6jnm6gp0cs7zlj71z22zz7bs1750b0jrfm2r";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = {
    homepage = "https://c-cube.github.io/ocaml-minisat/";
    description = "Simple bindings to Minisat-C";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
