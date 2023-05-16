{ lib
, fetchFromGitHub
, buildDunePackage
, menhir
, menhirLib
, uutf
}:

buildDunePackage rec {
  pname = "otoml";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-3bgeiwa0elisxZaWpwLqoKmeyTBKMW1IWdm6YdSIhSw=";
=======
    sha256 = "sha256-Xd3fHBN1f+tvgRFCxD/Gz8/lIvezknz7Zy3EtdqoTEM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [ menhirLib uutf ];

  meta = {
    description = "A TOML parsing and manipulation library for OCaml";
    changelog = "https://github.com/dmbaturin/otoml/raw/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
