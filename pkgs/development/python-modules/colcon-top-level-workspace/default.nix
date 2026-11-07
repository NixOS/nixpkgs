{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colcon,
  pytestCheckHook,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-top-level-workspace";
  version = "0-unstable-2024-11-22"; # this package has currently no version
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-top-level-workspace";
    rev = "6765772e8a007ed35c0d22983fe2bde8076d2ebc"; # this package has currently no tag
    hash = "sha256-oLV+ySi8nExQpkRdgETYbUz6YJV1an0XvyhfMJd67CI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [
    "colcon_top_level_workspace"
  ];

  meta = {
    description = "Extension for colcon to support top-level workspace";
    homepage = "http://colcon.readthedocs.io/";
    changelog = "https://github.com/colcon/colcon-top-level-workspace/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
