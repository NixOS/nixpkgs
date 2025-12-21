{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  base64,
  cmdliner,
  rresult,
  xmlm,
  yojson,
}:

buildDunePackage rec {
  pname = "rpclib";
  version = "10.0.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-rpc/releases/download/${version}/rpclib-${version}.tbz";
    hash = "sha256-HWLPNv8/WZKG/2x3oyZrBNnhTfc9P84HjVGrnEx7rTo=";
  };

  buildInputs = [
    cmdliner
    yojson
  ];
  propagatedBuildInputs = [
    base64
    rresult
    xmlm
  ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Light library to deal with RPCs in OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vyorkin ];
  };
}
