{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  setuptools,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyvisa";
  version = "1.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    tag = version;
    hash = "sha256-PHIhCiIfgLlvK490ue5DgLtkYYPMj+eC3ArYZbUANrc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test can't find cli tool bin path correctly
  disabledTests = [ "test_visa_info" ];

  meta = {
    description = "Python package for support of the Virtual Instrument Software Architecture (VISA)";
    homepage = "https://github.com/pyvisa/pyvisa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvnetbiz ];
  };
}
