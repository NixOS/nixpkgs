{
  lib,
  buildDunePackage,
  rpclib,
  alcotest,
  ppxlib,
  ppx_deriving,
  yojson,
}:

buildDunePackage {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  propagatedBuildInputs = [
    ppxlib
    rpclib
    ppx_deriving
  ];

  checkInputs = [
    alcotest
    yojson
  ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vyorkin ];
  };
}
