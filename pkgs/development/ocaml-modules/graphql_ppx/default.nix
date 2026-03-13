{
  lib,
  ocaml,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
  reason,
  result,
  ppxlib,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "graphql_ppx";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "reasonml-community";
    repo = "graphql-ppx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u49JHC8K5iMCOQRPYaMl00npJsIE6ePaeJ2jP/vnuvw=";
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

  meta = {
    broken = lib.versionAtLeast ocaml.version "5.4";
    homepage = "https://github.com/reasonml-community/graphql_ppx";
    description = "GraphQL PPX rewriter for Bucklescript/ReasonML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Zimmi48
      jtcoolen
    ];
  };
})
