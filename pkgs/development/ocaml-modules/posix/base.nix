{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  integers,
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    tag = "v${version}";
    hash = "sha256-Cd5D97Q+xiXtgo1yiNYq93GMLOBKrGgGV0fjrgRevZU=";
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
