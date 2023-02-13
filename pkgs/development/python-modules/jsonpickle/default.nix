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
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AyU4gEeV5zuU6tQQgArDh/223pj4iCrJV/zSR+OoUgA=";
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
