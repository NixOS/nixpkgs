{ lib, buildDunePackage, fetchFromGitHub, alcotest, cppo
, ocaml-migrate-parsetree, ppx_tools_versioned, reason, yojson }:

buildDunePackage rec {
  pname = "graphql_ppx";
  version = "1.0.1";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "reasonml-community";
    repo = "graphql-ppx";
    rev = "v${version}";
    sha256 = "0lvmv1sb0ca9mja6di1dbmsgjqgj3w9var4amv1iz9nhwjjx4cpi";
  };

  propagatedBuildInputs =
    [ cppo ocaml-migrate-parsetree ppx_tools_versioned reason yojson ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = false;

  useDune2 = true;

  meta = {
    homepage = "https://github.com/reasonml-community/graphql_ppx";
    description = "GraphQL PPX rewriter for Bucklescript/ReasonML";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Zimmi48 jtcoolen ];
  };
}
