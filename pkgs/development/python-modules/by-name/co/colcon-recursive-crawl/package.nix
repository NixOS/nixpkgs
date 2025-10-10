{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  colcon,
  # tests
  pytestCheckHook,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-recursive-crawl";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-recursive-crawl";
    tag = version;
    hash = "sha256-zmmEelMjsIbXy5LchZMtr2+x+Ne2c2PhexLjbkZJmm8=";
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
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [ "colcon_recursive_crawl" ];

  meta = {
    description = "Extension for colcon to recursively crawl for packages";
    homepage = "https://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-recursive-crawl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
