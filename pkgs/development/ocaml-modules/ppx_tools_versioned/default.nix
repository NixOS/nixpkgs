{ lib, fetchFromGitHub, buildDunePackage, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_tools_versioned";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "1hcmpnw26zf70a71r3d2c2c0mn8q084gdn1r36ynng6fv9hq6j0y";
  };

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  meta = with lib; {
    homepage = https://github.com/let-def/ppx_tools_versioned;
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
  };
}
