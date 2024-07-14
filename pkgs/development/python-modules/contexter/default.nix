{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "contexter";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xzCJCxqRUFFBSmNQ2Ooc3cp9Adj3Vrre2zC5vzBeoKg=";
  };

  meta = with lib; { };
}
