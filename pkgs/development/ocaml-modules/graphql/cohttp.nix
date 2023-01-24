{ lib, buildDunePackage, ocaml-crunch
, astring, cohttp, digestif, graphql, ocplib-endian
, alcotest, cohttp-lwt-unix, graphql-lwt
}:

buildDunePackage rec {
  pname = "graphql-cohttp";

  inherit (graphql) version src;

  duneVersion = "3";

  nativeBuildInputs = [ ocaml-crunch ];
  propagatedBuildInputs = [ astring cohttp digestif graphql ocplib-endian ];

  nativeCheckInputs = lib.optionals doCheck [ alcotest cohttp-lwt-unix graphql-lwt ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Run GraphQL servers with “cohttp”";
  };

}


