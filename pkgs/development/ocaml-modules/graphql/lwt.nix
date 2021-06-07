{ buildDunePackage, alcotest, graphql, ocaml_lwt }:

buildDunePackage rec {
  pname = "graphql-lwt";

  inherit (graphql) version useDune2 src;

  propagatedBuildInputs = [ graphql ocaml_lwt ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}

