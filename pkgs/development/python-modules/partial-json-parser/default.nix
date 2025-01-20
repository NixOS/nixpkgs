{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "partial-json-parser";
  version = "0.2.1.1.post4";
  pyproject = true;

  src = fetchPypi {
    pname = "partial_json_parser";
    inherit version;
    hash = "sha256-o48Rzriahvv70KytQXDUF9yzF2IcbsmrXytmUvP0YL8=";
  };

  build-system = [
    pdm-backend
  ];
}
