{
  buildDunePackage,
  alcotest,
  graphql,
  ocaml_lwt,
}:

buildDunePackage {
  pname = "graphql-lwt";

  inherit (graphql) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    graphql
    ocaml_lwt
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}
