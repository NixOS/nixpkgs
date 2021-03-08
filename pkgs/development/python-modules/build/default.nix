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
  version = "0.1.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CLK1gJj/YX0RVAVsefinC+7Rj3z6cQvKI6ByGWkQ1bQ=";
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
