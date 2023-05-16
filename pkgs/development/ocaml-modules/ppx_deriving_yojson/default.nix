<<<<<<< HEAD
{ lib, buildDunePackage, fetchFromGitHub, ocaml, ppxlib, ounit
=======
{ lib, buildDunePackage, fetchFromGitHub, ppxlib, ounit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ppx_deriving, yojson
}:

let param =
  if lib.versionAtLeast ppxlib.version "0.26" then {
    version = "3.7.0";
    sha256 = "sha256-niKxn1fX0mL1MhlZvbN1wgRed9AHh+z9s6l++k1VX9k=";
  }  else {
    version = "3.6.1";
    sha256 = "1icz5h6p3pfj7my5gi7wxpflrb8c902dqa17f9w424njilnpyrbk";
  }
; in

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  inherit (param) version;

  minimalOCamlVersion = "4.07";
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yojson ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [ ounit ];

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
