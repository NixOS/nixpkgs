{ lib, buildDunePackage, cohttp-lwt, graphql-cohttp, graphql-lwt, irmin
, alcotest, alcotest-lwt, logs, yojson, cohttp-lwt-unix, cacert
}:

buildDunePackage rec {

  pname = "irmin-graphql";

  inherit (irmin) version src;

  propagatedBuildInputs = [ cohttp-lwt graphql-cohttp graphql-lwt irmin ];

  doCheck = true;

  buildInputs = checkInputs;

  checkInputs = [
    alcotest
    alcotest-lwt
    logs
    cohttp-lwt-unix
    yojson
    cacert
  ];

  meta = irmin.meta // {
    description = "GraphQL server for Irmin";
  };

}



