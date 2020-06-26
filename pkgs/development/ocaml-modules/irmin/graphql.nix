{ lib, buildDunePackage, cohttp-lwt, graphql-cohttp, graphql-lwt, irmin }:

buildDunePackage rec {

  pname = "irmin-graphql";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [ cohttp-lwt graphql-cohttp graphql-lwt irmin ];

  doCheck = true;

  meta = irmin.meta // {
    description = "GraphQL server for Irmin";
  };

}



