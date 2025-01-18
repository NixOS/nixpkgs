{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
  reason,
  result,
  ppxlib,
  yojson,
}:

buildDunePackage rec {
  pname = "graphql_ppx";
  version = "1.2.2";

  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "reasonml-community";
    repo = "graphql-ppx";
    rev = "v${version}";
    sha256 = "sha256-+WJhA2ixZHiSZBoX14dnQKk7JfVAIME4JooNSnhRp44=";
  };

  nativeBuildInputs = [ reason ];

  buildInputs = [
    ppxlib
    reason
  ];

  propagatedBuildInputs = [
    reason
    result
    yojson
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/reasonml-community/graphql_ppx";
    description = "GraphQL PPX rewriter for Bucklescript/ReasonML";
    license = licenses.mit;
    maintainers = with maintainers; [
      Zimmi48
      jtcoolen
    ];
  };
}
