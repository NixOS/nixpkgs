{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyvisa";
  version = "1.14.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    rev = "refs/tags/${version}";
    hash = "sha256-GKrgUK2nSZi+8oJoS45MjpU9+INEgcla9Kaw6ceNVp0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test can't find cli tool bin path correctly
  disabledTests = [ "test_visa_info" ];

  meta = with lib; {
    description = "Python package for support of the Virtual Instrument Software Architecture (VISA)";
    homepage = "https://github.com/pyvisa/pyvisa";
    license = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
