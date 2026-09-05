{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:
buildPythonPackage rec {
  pname = "colcon-powershell";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-powershell";
    tag = version;
    hash = "sha256-QABGwVslQNw89/fxXC3dmo7MJld5Nf24feUOaHZJDF4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
    "test/test_spell_check.py"
  ];

  pythonImportsCheck = [
    "colcon_powershell"
  ];

  meta = {
    description = "Extension for colcon-core to provide PowerShell scripts";
    homepage = "http://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-powershell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
