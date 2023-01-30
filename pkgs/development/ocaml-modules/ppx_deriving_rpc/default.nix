{ lib, buildDunePackage, rpclib, alcotest, ppxlib, ppx_deriving, yojson }:

buildDunePackage rec {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version useDune2 src;

  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [ ppxlib rpclib ppx_deriving ];

  nativeCheckInputs = [ alcotest yojson ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
