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
  version = "0.22.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "spacetelescope";
    repo = "gwcs";
    tag = version;
    hash = "sha256-9s3HwKFpUXb0aqcSEJVL2SB6G2pQc8xQT5HdZYoHd/I=";
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
    changelog = "https://github.com/spacetelescope/gwcs/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
