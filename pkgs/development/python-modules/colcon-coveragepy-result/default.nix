{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  coverage,
  pytest-cov-stub,
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
    pytest-cov-stub
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_coveragepy_result"
  ];

  disabledTestPaths = [
    "test/test_flake8.py" # flake tests doesn't work currently
  ];

  meta = {
    description = "Colcon extension for collecting coverage.py results";
    homepage = "https://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-coveragepy-result.git";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
