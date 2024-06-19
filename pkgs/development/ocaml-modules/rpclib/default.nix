{ lib, fetchurl, buildDunePackage
, alcotest
, base64, cmdliner, rresult, xmlm, yojson
}:

buildDunePackage rec {
  pname = "rpclib";
  version = "9.0.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-rpc/releases/download/${version}/rpclib-${version}.tbz";
    hash = "sha256-ziPrdWwCjZN0vRmCMpa923wjfT8FVFLTDRz30VIW6WM=";
  };

  buildInputs = [ cmdliner yojson ];
  propagatedBuildInputs = [ base64 rresult xmlm ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Light library to deal with RPCs in OCaml";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
