{
  lib,
  # Build system
  buildPythonPackage,
  hatchling,
  fetchFromGitHub,
  # Dependencies
  flake8,
  pytest,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "flake8-builtins";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gforcada";
    repo = "flake8-builtins";
    tag = version;
    hash = "sha256-5fgtbEp9yAEdNoi1zVDfPzm+/+7I2DnuzY6dOsQEkw4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    flake8
  ];

  pythonImportsCheck = [
    "flake8_builtins"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "run_tests.py" ];

  meta = {
    description = "Check for python builtins being used as variables or parameters";
    homepage = "https://github.com/gforcada/flake8-builtins";
    changelog = "https://github.com/gforcada/flake8-builtins/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ gurjaka ];
  };
}
