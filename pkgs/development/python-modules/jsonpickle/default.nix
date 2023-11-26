{ lib
, buildPythonPackage
, fetchPypi
, pytest
, setuptools-scm
, toml
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-43q7pL+zykpGR9KLufRwZDb3tGyKgzO0pxirr6jkazc=";
  };

  nativeCheckInputs = [ pytest ];

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ];

  checkPhase = ''
    rm pytest.ini
    pytest tests/jsonpickle_test.py
  '';

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = "http://jsonpickle.github.io/";
    license = lib.licenses.bsd3;
  };

}
