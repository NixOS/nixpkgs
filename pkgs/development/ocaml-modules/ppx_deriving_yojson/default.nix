{ lib, buildDunePackage, fetchFromGitHub
, ounit, ppxlib, ppx_deriving, yojson, result
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.6.1";

  minimumOCamlVersion = "4.05";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "1icz5h6p3pfj7my5gi7wxpflrb8c902dqa17f9w424njilnpyrbk";
  };

  propagatedBuildInputs = [ result ppx_deriving yojson ppxlib ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
