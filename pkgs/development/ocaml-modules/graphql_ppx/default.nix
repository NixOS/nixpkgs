{ lib, buildDunePackage, fetchFromGitHub, alcotest, cppo
, ocaml-migrate-parsetree, ppx_tools_versioned, reason, result, yojson }:

buildDunePackage rec {
  pname = "graphql_ppx";
  version = "0.7.1";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "reasonml-community";
    repo = "graphql_ppx";
    rev = "v${version}";
    sha256 = "0gpzwcnss9c82whncyxfm6gwlkgh9hy90329hrazny32ybb470zh";
  };

  propagatedBuildInputs =
    [ cppo ocaml-migrate-parsetree ppx_tools_versioned reason result yojson ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = false;

  meta = {
    homepage = "https://github.com/reasonml-community/graphql_ppx";
    description = "GraphQL PPX rewriter for Bucklescript/ReasonML";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Zimmi48 jtcoolen ];
  };
}
