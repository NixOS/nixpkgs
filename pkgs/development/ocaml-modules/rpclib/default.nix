{ lib, fetchurl, buildDunePackage, ocaml
, alcotest
, base64, cmdliner, rresult, xmlm, yojson
}:

buildDunePackage rec {
  pname = "rpclib";
  version = "8.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-rpc/releases/download/v${version}/rpclib-v${version}.tbz";
    sha256 = "0fbajg8wq8hjhkvvfnq68br0m0pa8zf2qzadhfgi2nnr9713rada";
  };

  buildInputs = [ cmdliner yojson ];
  propagatedBuildInputs = [ base64 rresult xmlm ];
  checkInputs = [ alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Light library to deal with RPCs in OCaml";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
