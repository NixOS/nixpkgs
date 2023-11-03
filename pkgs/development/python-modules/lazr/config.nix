{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, lazr_delegates
, zope_interface
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lazr-config";
  version = "2.2.3";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr.config";
    inherit version;
    hash = "sha256-t0pz+LY+bcZzL8Hz2I4vI2WW3fCJ724XlOzgYOjPq+E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    lazr_delegates
    zope_interface
  ];

  pythonImportsCheck = [
    "lazr.config"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # change the directory to avoid a namespace-related problem
  # ModuleNotFoundError: No module named 'lazr.delegates'
  preCheck = ''
    cd $out
  '';

  pythonNamespaces = [
    "lazr"
  ];

  meta = with lib; {
    description = "Create configuration schemas, and process and validate configurations";
    homepage = "https://launchpad.net/lazr.config";
    changelog = "https://git.launchpad.net/lazr.config/tree/NEWS.rst?h=${version}";
    license = licenses.lgpl3Only;
  };
}
