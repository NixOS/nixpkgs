{ lib
, astropy
, buildPythonPackage
, fetchPypi
, importlib-resources
, jmespath
, jsonschema
, numpy
, packaging
, pytest-astropy
, pytestCheckHook
, pythonOlder
, pyyaml
, semantic-version
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "2.8.3";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de0f70ffb2e0d539461940d6f7529c3548541fa098d8edc37af256af61c09b44";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jmespath
    jsonschema
    numpy
    packaging
    pyyaml
    semantic-version
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    pytest-astropy
    astropy
    pytestCheckHook
  ];

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pythonImportsCheck = [ "asdf" ];

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/spacetelescope/asdf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
