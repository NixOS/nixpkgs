{ lib, fetchFromGitHub, buildDunePackage, ocaml, camlp-streams, markup, ounit2 }:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "1.0.0";

  minimalOCamlVersion = "4.03";

<<<<<<< HEAD
=======
  duneVersion = "3";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    hash = "sha256-PZkhN5vkkLu8A3gYrh5O+nq9wFtig0Q4qD8zLGUGTRI=";
  };

  propagatedBuildInputs = [ camlp-streams markup ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = lib.versionAtLeast ocaml.version "4.04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [ ounit2 ];

  meta = {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
