{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  integers,
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    tag = "v${version}";
    hash = "sha256-JC4xLxSLXahR6TDFZzgYMJfussETZ4SRCmbsytPgJxg=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    ctypes
    integers
  ];

  meta = {
    homepage = "https://www.liquidsoap.info/ocaml-posix/";
    description = "Base module for the posix bindings";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
