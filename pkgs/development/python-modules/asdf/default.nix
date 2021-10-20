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
  version = "2.8.1";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bp3fME3FTa5vcj7qUoUEGqvuI2uwSpI13zDcFgWvbJw=";
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
