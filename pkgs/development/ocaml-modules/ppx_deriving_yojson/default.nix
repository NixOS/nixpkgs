{ lib, buildDunePackage, fetchFromGitHub, ppxfind, ounit
, ppx_deriving, yojson
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.3";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "1gbfziw03r9azqlsmyn6izrgrf1xc30s88jgdany1kblpgq41rsz";
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
