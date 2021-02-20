{ lib
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
, toml
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9b99b28a9e6a3043ec993552db79f4389da11afcb1d0246d93c79f4b5e64062";
  };

  checkInputs = [ pytest ];

  nativeBuildInputs = [
    setuptools_scm
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
