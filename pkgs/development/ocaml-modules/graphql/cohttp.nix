{
  lib,
  buildDunePackage,
  ocaml-crunch,
  astring,
  cohttp,
  digestif,
  graphql,
  ocplib-endian,
  alcotest,
  cohttp-lwt-unix,
  graphql-lwt,
}:

buildDunePackage rec {
  pname = "graphql-cohttp";

  inherit (graphql) version src;

  duneVersion = "3";

  nativeBuildInputs = [ ocaml-crunch ];
  propagatedBuildInputs = [
    astring
    cohttp
    digestif
    graphql
    ocplib-endian
  ];

  checkInputs = lib.optionals doCheck [
    alcotest
    cohttp-lwt-unix
    graphql-lwt
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace graphql-cohttp/src/graphql_websocket.ml \
      --replace-fail "~flush:true ()" "~version:\`HTTP_1_1 ()"
  '';

  meta = graphql.meta // {
    description = "Run GraphQL servers with “cohttp”";
  };

}
