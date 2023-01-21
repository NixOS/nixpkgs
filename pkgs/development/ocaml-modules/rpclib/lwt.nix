{ lib, buildDunePackage, rpclib
, lwt
, alcotest-lwt, ppx_deriving_rpc, yojson
}:

buildDunePackage {
  pname = "rpclib-lwt";
  inherit (rpclib) version useDune2 src;

  propagatedBuildInputs = [ lwt rpclib ];

  nativeCheckInputs = [ alcotest-lwt ppx_deriving_rpc yojson ];
  doCheck = true;

  meta = rpclib.meta // {
    description = "A library to deal with RPCs in OCaml - Lwt interface";
  };
}
