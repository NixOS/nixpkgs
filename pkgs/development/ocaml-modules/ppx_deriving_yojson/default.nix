{ lib, buildDunePackage, fetchFromGitHub, ocaml, ppxlib, ounit
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

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yojson ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit ];

  meta = {
    description = "Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
