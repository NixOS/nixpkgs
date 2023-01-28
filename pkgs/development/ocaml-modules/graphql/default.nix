{ buildDunePackage, alcotest, graphql_parser, rresult, yojson }:

buildDunePackage rec {
  pname = "graphql";

  inherit (graphql_parser) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ graphql_parser rresult yojson ];

  nativeCheckInputs = [ alcotest ];

  doCheck = true;

  meta = graphql_parser.meta // {
    description = "Build GraphQL schemas and execute queries against them";
  };

}
