{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "pbrt";
  version = "2.4";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "mransan";
    repo = "ocaml-protoc";
    rev = "${version}.0";
    hash = "sha256-EXugdcjALukSjB31zAVG9WiN6GMGXi2jlhHWaZ+p+uM=";
  };

  meta = with lib; {
    homepage = "https://github.com/mransan/ocaml-protoc";
    description = "Runtime library for Protobuf tooling";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}

