{ buildDunePackage, alcotest, graphql, ocaml_lwt }:

buildDunePackage rec {
  pname = "graphql-lwt";

  inherit (graphql) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ graphql ocaml_lwt ];

  nativeCheckInputs = [ alcotest ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}

