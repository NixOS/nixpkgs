{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  notify2,
  pytestCheckHook,
  scspell,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-notification";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-notification";
    tag = version;
    hash = "sha256-5cnuUVHHjn85RMz9r24/zRQdvDt+JETAWOW1Fw6WEtM=";
  };
  build-system = [ setuptools ];
  dependencies = [
    colcon
    notify2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_notification"
  ];

  disabledTestPaths = [
    # Linting/formatting tests are not relevant and would require extra dependencies
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to provide status notifications";
    homepage = "https://github.com/colcon/colcon-notification";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
