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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hGhM/FM4pTQXPI3WmAnkDyhl0L4fiit6+EZeW5aNz6k=";
  };

  checkInputs = [ pytest ];

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
