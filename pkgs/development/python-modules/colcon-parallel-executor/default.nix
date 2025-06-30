{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-parallel-executor";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-parallel-executor";
    tag = version;
    hash = "sha256-uhVl1fqoyMF/L98PYCmM6m7+52c4mWj2qlna5sz/RxE=";
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

  pythonImportsCheck = [
    "colcon_parallel_executor"
  ];

  disabledTestPaths = [
    # Skip the linter tests
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to process packages in parallel";
    homepage = "https://github.com/colcon/colcon-parallel-executor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
