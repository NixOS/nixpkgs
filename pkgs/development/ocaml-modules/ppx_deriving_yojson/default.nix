{ lib, buildDunePackage, fetchFromGitHub, ppxfind, ounit
, ppx_deriving, yojson
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.5.2";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "098rpjbykp7ffhs62mgxlk7349l665xh1w1m8ldj6rjb690cc945";
  };

  buildInputs = [ ppxfind ounit ];

  propagatedBuildInputs = [ ppx_deriving yojson ];

  doCheck = true;

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
