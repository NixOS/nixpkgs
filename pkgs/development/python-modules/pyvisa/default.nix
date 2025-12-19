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
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    tag = version;
    hash = "sha256-KvRY+JZbZLjENwRdFi2D0VuNgf8Oaxip0mkLxvJfS58=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test can't find cli tool bin path correctly
  disabledTests = [ "test_visa_info" ];

  meta = {
    description = "Python package for support of the Virtual Instrument Software Architecture (VISA)";
    homepage = "https://github.com/pyvisa/pyvisa";
    changelog = "https://github.com/pyvisa/pyvisa/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvnetbiz ];
  };
}
