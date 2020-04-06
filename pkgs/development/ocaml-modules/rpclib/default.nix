{ lib, fetchFromGitHub, buildDunePackage, alcotest, cmdliner, rresult, result, xmlm, yojson }:

buildDunePackage rec {
  pname = "rpclib";
  version = "6.0.0";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-rpc";
    rev = "v${version}";
    sha256 = "0bmr20sj7kybjjlwd42irj0f5zlnxcw7mxa1mdgxkki9bmhsqr51";
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
