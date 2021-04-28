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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0be49cba80ea6f87a168aa8168d717d00c6ca07ba83df3cec32d3b30bfe6fb9a";
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
