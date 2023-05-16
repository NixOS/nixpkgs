{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "parsetoml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "NimParsers";
    repo = "parsetoml";
    rev = "v${version}";
    hash = "sha256-jtqn59x2ZRRgrPir6u/frsDHnl4kvTJWpbejxti8aHY=";
  };

<<<<<<< HEAD
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib;
    src.meta // {
      description = "A Nim library to parse TOML files";
      license = [ licenses.mit ];
      maintainers = with maintainers; [ sikmir ];
    };
}
