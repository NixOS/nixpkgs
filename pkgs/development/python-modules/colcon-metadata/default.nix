{
  lib,
  buildPythonPackage,
  colcon,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pyyaml,
  scspell,
  setuptools,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "colcon-metadata";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-metadata";
    tag = version;
    hash = "sha256-CCyhtTsSjaeY/OKO8F1zYpk8yA4HlUoXVTVkyYEpVU8=";
  };
  build-system = [ setuptools ];

  dependencies = [
    colcon
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [
    "colcon_metadata"
  ];

  meta = {
    description = "Extension for colcon-core to read package metadata from files";
    homepage = "http://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-metadata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
