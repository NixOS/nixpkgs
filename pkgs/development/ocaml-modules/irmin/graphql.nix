{ lib, buildDunePackage, cohttp-lwt, graphql-cohttp, graphql-lwt, irmin
, alcotest, alcotest-lwt, logs, yojson, cohttp-lwt-unix
}:

buildDunePackage rec {

  pname = "irmin-graphql";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [ cohttp-lwt graphql-cohttp graphql-lwt irmin ];

  doCheck = true;
  checkInputs = [
    alcotest
    alcotest-lwt
    logs
    cohttp-lwt-unix
    yojson
  ];

  meta = irmin.meta // {
    description = "GraphQL server for Irmin";
  };

}



