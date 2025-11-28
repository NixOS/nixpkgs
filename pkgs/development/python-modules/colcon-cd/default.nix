{
  buildPythonPackage,
  colcon,
  colcon-argcomplete,
  colcon-package-information,
  fetchFromGitHub,
  lib,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colcon-cd";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-cd";
    tag = "${version}";
    hash = "sha256-eOo1DqTvYazr+wWraG9PZe0tTCgaAvhWtELG5rlaGSs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    colcon-package-information
  ];

  optional-dependencies = [ colcon-argcomplete ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
    "test/test_spell_check.py"
  ];

  pythonImportCheck = [ "colcon_cd" ];

  meta = {
    description = "A shell function for colcon-core to change the current working directory.";
    homepage = "https://github.com/colcon/colcon-cd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amronos ];
  };
}
