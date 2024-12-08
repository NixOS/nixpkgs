{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  hatchling,
  numpy,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymodes";
  version = "2.19";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "junzis";
    repo = "pyModeS";
    rev = "refs/tags/v${version}";
    hash = "sha256-rVxqtT/sBFQM2Y+GPR2Tc5J2skavvjxwPB7paDBqYRQ=";
  };

  build-system = [
    cython
    hatchling
    setuptools
  ];

  dependencies = [
    numpy
    pyzmq
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyModeS" ];

  meta = with lib; {
    description = "Python Mode-S and ADS-B Decoder";
    homepage = "https://github.com/junzis/pyModeS";
    changelog = "https://github.com/junzis/pyModeS/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ snicket2100 ];
  };
}
