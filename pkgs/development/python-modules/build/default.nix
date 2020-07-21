{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, toml
, pep517
, packaging
, isPy3k
, typing
, pythonOlder
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "build";
  version = "0.0.3.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "757b5542168326b6f1898a1ce1131bb2cf306ee4c7e54e39c815c5be217ff87d";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    toml
    pep517
    packaging
  ] ++ lib.optionals (!isPy3k) [
    typing
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A simple, correct PEP517 package builder";
    license = lib.licenses.mit;
  };
}