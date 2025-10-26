{
  buildPythonPackage,
  colcon,
  fetchFromGitHub,
  lib,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colcon-bash";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-bash";
    tag = "${version}";
    hash = "sha256-rdUo+aLnCkQBPwBVosPYhVZqBPXeJCKKWAv+0mQBJ8Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ colcon ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
    "test/test_spell_check.py"
  ];

  pythonImportCheck = [ "colcon_bash" ];

  meta = {
    description = "An extension for colcon-core to provide Bash scripts.";
    homepage = "https://github.com/colcon/colcon-bash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amronos ];
  };
}
