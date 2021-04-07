{ lib, fetchFromGitHub, buildDunePackage
, stdlib-shims
}:

buildDunePackage rec {
  pname = "ocaml-protoc";
  version = "2.0.2";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mransan";
    repo = "ocaml-protoc";
    rev = version;
    sha256 = "1vlnjqqpypmjhlyrxfzla79y4ilmc9ggz311giy6vmh4cyzl29h3";
  };

  buildInputs = [ stdlib-shims ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mransan/ocaml-protoc";
    description = "A Protobuf Compiler for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
