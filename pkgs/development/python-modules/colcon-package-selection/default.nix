{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-package-selection";
  version = "0.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-package-selection";
    tag = version;
    hash = "sha256-27Kk1l/Zvc18d4EfFPdUR/yeCS9fU1VJuHglyjPwnh0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_package_selection"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon to select the packages to process";
    homepage = "http://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-package-selection";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
