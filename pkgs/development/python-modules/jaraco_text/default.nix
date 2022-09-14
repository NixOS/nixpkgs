{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-resources
, jaraco_functools
, jaraco-context
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
    jaraco-context
    jaraco_functools
  ] ++ lib.optional (pythonOlder "3.9") [
    importlib-resources
  ];

  # no tests in pypi package
  doCheck = false;

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
