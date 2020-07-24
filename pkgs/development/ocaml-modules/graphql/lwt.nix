{ lib, buildDunePackage, alcotest, graphql, ocaml_lwt }:

buildDunePackage rec {
  pname = "graphql-lwt";

  inherit (graphql) version src;

  propagatedBuildInputs = [ graphql ocaml_lwt ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}

