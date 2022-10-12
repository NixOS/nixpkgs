{ lib, buildDunePackage, fetchFromGitHub, ppxlib, ounit
, ppx_deriving, yojson
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.7.0";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "sha256-niKxn1fX0mL1MhlZvbN1wgRed9AHh+z9s6l++k1VX9k=";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yojson ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
