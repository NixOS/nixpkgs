{
  lib,
  buildDunePackage,
  fetchpatch,
  rpclib,
  alcotest,
  ppxlib,
  ppx_deriving,
  yojson,
}:

buildDunePackage {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  minimalOCamlVersion = "4.08";

  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/mirage/ocaml-rpc/commit/678b7c0e59f6add174f2a732861be21c3e9583d0.patch";
    hash = "sha256-6Vl4/C02NQ/nPn+h9I/eT86R7GLZ/C8nSqBs4Ywzhwc=";
  });

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

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
