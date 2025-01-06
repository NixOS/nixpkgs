{
  lib,
  buildDunePackage,
  rpclib,
  alcotest,
  ppxlib,
  ppx_deriving,
  yojson,
}:

buildDunePackage rec {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

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
