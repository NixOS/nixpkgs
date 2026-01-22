{
  buildDunePackage,
  alcotest,
  graphql,
  lwt,
}:

buildDunePackage {
  pname = "graphql-lwt";

  inherit (graphql) version src;

  propagatedBuildInputs = [
    graphql
    lwt
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}
