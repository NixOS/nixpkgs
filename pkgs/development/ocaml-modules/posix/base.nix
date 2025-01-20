{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  integers,
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    rev = "v${version}";
    hash = "sha256-x34Tki2gBAy48HYNo4dw833u132nle3ilQN1DIbrAjw=";
  };

  duneVersion = "3";
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
