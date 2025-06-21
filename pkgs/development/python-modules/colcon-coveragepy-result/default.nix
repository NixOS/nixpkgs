{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  coverage,
  pytest-cov,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-coveragepy-result";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-coveragepy-result";
    tag = version;
    hash = "sha256-+xjrmiWaDPjoRwjgP4Ui6+vuG4Nc4ur8DdC8ddiXAG0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    coverage
  ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_coveragepy_result"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Colcon extension for collecting coverage.py results";
    homepage = "https://colcon.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
