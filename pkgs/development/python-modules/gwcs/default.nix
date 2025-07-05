{
  lib,
  asdf-astropy,
  asdf-wcs-schemas,
  asdf,
  astropy,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytest-astropy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gwcs";
  version = "0.25.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "spacetelescope";
    repo = "gwcs";
    tag = version;
    hash = "sha256-jGO3/qFNL8aovlU/jXIZpk2GHmwZ+o8tSSqnPHgtFqU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-astropy
    asdf-wcs-schemas
    astropy
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gwcs" ];

  meta = with lib; {
    description = "Module to manage the Generalized World Coordinate System";
    homepage = "https://github.com/spacetelescope/gwcs";
    changelog = "https://github.com/spacetelescope/gwcs/blob/${src.tag}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
