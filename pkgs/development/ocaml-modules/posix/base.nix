{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  integers,
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    tag = "v${version}";
    hash = "sha256-JKJIiuo4lW8DmcK1mJlT22784J1NS2ig860jDbRIjIo=";
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
