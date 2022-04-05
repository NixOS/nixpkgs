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
  version = "3.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-p/nMG0Sl8wlqIWy9EwtlDHprLJ+ABbAArpfzKSOafAA=";
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
