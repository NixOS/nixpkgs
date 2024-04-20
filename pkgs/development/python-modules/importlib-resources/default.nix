{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# dependencies
, importlib-metadata

# tests
, jaraco-collections
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "6.1.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-VvtFJRl7eFRKM1TqJ3k5UquT+TW7S/dGuEa7EBUCDys=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jaraco-collections
  ];

  pythonImportsCheck = [
    "importlib_resources"
  ];

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
