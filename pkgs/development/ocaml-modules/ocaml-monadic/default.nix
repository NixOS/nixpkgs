{ lib, fetchFromGitHub, buildDunePackage
, ocaml-migrate-parsetree, ppx_tools_versioned
}:

buildDunePackage rec {
  pname = "ocaml-monadic";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "zepalmer";
    repo = pname;
    rev = version;
    sha256 = "1zcwydypk5vwfn1g7srnl5076scwwq5a5y8xwcjl70pc4cpzszll";
  };

  buildInputs = [ ppx_tools_versioned ];
  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  meta = {
    inherit (src.meta) homepage;
    description = "A PPX extension to provide an OCaml-friendly monadic syntax";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
