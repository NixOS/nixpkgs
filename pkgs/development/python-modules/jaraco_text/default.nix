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
  version = "3.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mzpd8hSPcTlxhgfN81L+HZUWKXGnKZw4Dcwk2rAWiYA=";
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

  nativeCheckInputs = [
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
