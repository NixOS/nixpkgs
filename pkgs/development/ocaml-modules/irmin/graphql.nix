{ lib, buildDunePackage, cohttp-lwt, cohttp-lwt-unix, graphql-cohttp, graphql-lwt, irmin, git-unix
, alcotest, alcotest-lwt, logs, yojson, cacert
}:

buildDunePackage rec {

  pname = "irmin-graphql";

  inherit (irmin) version src;

  propagatedBuildInputs = [ cohttp-lwt cohttp-lwt-unix graphql-cohttp graphql-lwt irmin git-unix ];

  doCheck = true;

  checkInputs = [
    alcotest
    alcotest-lwt
    logs
    yojson
    cacert
  ];

  meta = irmin.meta // {
    description = "GraphQL server for Irmin";
  };
}
