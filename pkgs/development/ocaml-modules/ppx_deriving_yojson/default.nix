{ lib, buildDunePackage, fetchFromGitHub, ppxlib, ounit
, ppx_deriving, yojson
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.6.1";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "1icz5h6p3pfj7my5gi7wxpflrb8c902dqa17f9w424njilnpyrbk";
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
