{ stdenv, fetchFromGitHub, buildDunePackage
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

buildDunePackage rec {
  pname = "ppxlib";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "0my9x7sxb329h0lzshppdaawiyfbaw6g5f41yiy7bhl071rnlvbv";
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs ocaml-migrate-parsetree ppx_derivers stdio
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
