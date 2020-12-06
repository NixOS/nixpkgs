{ lib, fetchurl, buildDunePackage
, alcotest
, base64, cmdliner, rresult, xmlm, yojson
}:

buildDunePackage rec {
  pname = "rpclib";
  version = "8.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-rpc/releases/download/v${version}/rpclib-v${version}.tbz";
    sha256 = "1kqbixk4d9y15ns566fiyzid5jszkamm1kv7iks71invv33v7krz";
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
