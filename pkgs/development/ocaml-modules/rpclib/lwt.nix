{ lib
, buildDunePackage
, rpclib
, lwt
, alcotest-lwt
, ppx_deriving_rpc
, yojson
}:

buildDunePackage {
  pname = "rpclib-lwt";
  inherit (rpclib) version src;
  duneVersion = "3";

  propagatedBuildInputs = [ lwt rpclib ];

  checkInputs = [ alcotest-lwt ppx_deriving_rpc yojson ];
  doCheck = true;

  meta = rpclib.meta // {
    description = "A library to deal with RPCs in OCaml - Lwt interface";
  };
}
