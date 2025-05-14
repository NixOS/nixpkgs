{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  #dependencies
  colcon,
  pyaml,
  # tests
  pytestCheckHook,
  pytest-cov-stub,
  pytest-repeat,
  pytest-rerunfailures,
  scspell,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "colcon-defaults";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-defaults";
    tag = version;
    hash = "sha256-Nb6D9jpbCvUnCNgRLBgWQFybNx0hyWVLSKj6gmTWjVs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    colcon
    pyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-repeat
    pytest-rerunfailures
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip formatting checks to prevent depending on flake8
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [ "colcon_defaults" ];

  meta = {
    description = "Extension for colcon to read defaults from a config file";
    homepage = "https://github.com/colcon/colcon-defaults";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
