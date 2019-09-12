{ stdenv, fetchFromGitHub, buildDunePackage, alcotest, cmdliner, rresult, result, xmlm, yojson }:

buildDunePackage rec {
  pname = "rpclib";
  version = "5.9.0";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-rpc";
    rev = "v${version}";
    sha256 = "1swnnmmnkn53mxqpckdnd1j8bz0wksqznjbv0zamspxyqybmancq";
  };

  buildInputs = [ alcotest cmdliner yojson ];
  propagatedBuildInputs = [ rresult result xmlm ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Light library to deal with RPCs in OCaml";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
