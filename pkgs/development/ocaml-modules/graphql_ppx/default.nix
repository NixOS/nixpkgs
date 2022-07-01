{ lib, buildDunePackage, fetchFromGitHub, alcotest, reason
, ppxlib
, yojson }:

buildDunePackage rec {
  pname = "graphql_ppx";
  version = "1.2.2";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "reasonml-community";
    repo = "graphql-ppx";
    rev = "v${version}";
    sha256 = "sha256-+WJhA2ixZHiSZBoX14dnQKk7JfVAIME4JooNSnhRp44=";
  };

  buildInputs = [ ppxlib ];

  propagatedBuildInputs = [
    reason
    yojson
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  useDune2 = true;

  meta = {
    homepage = "https://github.com/reasonml-community/graphql_ppx";
    description = "GraphQL PPX rewriter for Bucklescript/ReasonML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zimmi48 jtcoolen ];
  };
}
