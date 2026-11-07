{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  serialx,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pymonoprice";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pymonoprice";
    tag = "v${version}";
    hash = "sha256-UwP2R3gpu2gNgIEzyA9QSvPx40HfPALXFwHy4aJS6XA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    serialx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymonoprice" ];

  meta = {
    description = "Python 3 interface implementation for Monoprice 6 zone amplifier";
    homepage = "https://github.com/OnFreund/pymonoprice";
    changelog = "https://github.com/OnFreund/pymonoprice/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
