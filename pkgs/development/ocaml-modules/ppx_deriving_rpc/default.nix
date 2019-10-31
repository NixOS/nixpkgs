{ lib, buildDunePackage, rpclib, ppxfind, ppx_deriving, cppo }:

buildDunePackage rec {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  buildInputs = [ ppxfind cppo ];

  propagatedBuildInputs = [ rpclib ppx_deriving ];

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
