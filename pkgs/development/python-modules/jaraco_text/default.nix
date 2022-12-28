{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, autocommand
, importlib-resources
, jaraco_functools
, jaraco-context
, inflect
, pathlib2
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1XzURIpYgCAxhCXgQZTol/lvwjuSuC/5MIok1cvys/s=";
  };

  pythonNamespaces = [
    "jaraco"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    autocommand
    jaraco-context
    jaraco_functools
    inflect
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.10") [
    pathlib2
  ];

  pythonImportsCheck = [
    "jaraco.text"
  ];

  meta = with lib; {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
