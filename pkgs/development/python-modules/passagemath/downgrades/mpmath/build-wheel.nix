{
  buildPythonPackage,
  fetchPypi,
  lib,
  python,
  ...
}:
let
  wheel = {
    pname = "mpmath";
    version = "1.3.0";
    dist = "py3";
    python = "py3";
    platform = "any";
    abi = "none";
    hash = "sha256-oLK5/oC7zYGmZH/xMQhzjPtILUgdgmzA4C9bNeXIjSw=";
  };
in
buildPythonPackage rec {
  inherit (wheel) pname version;
  format = "wheel";

  src = fetchPypi (
    {
      pname = "mpmath";
      inherit format;
    }
    // wheel
  );
}
