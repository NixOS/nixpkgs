{ lib, fetchFromGitHub, buildDunePackage, alcotest, cmdliner, rresult, result, xmlm, yojson }:

buildDunePackage rec {
  pname = "rpclib";
  version = "7.0.0";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-rpc";
    rev = "v${version}";
    sha256 = "0d8nb272mjxkq5ddn65cy9gjpa8yvd0v3jv3wp5xfh9gj29wd2jj";
  };

  buildInputs = [ alcotest cmdliner yojson ];
  propagatedBuildInputs = [ rresult result xmlm ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Light library to deal with RPCs in OCaml";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
