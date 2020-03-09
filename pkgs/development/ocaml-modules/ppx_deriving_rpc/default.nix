{ lib, buildDunePackage, rpclib, ppxlib, ppx_deriving }:

buildDunePackage rec {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  buildInputs = [ ppxlib ];

  propagatedBuildInputs = [ rpclib ppx_deriving ];

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
