{
  lib,
  buildPythonPackage,
  colcon,
  colcon-installed-package-information,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  scspell,
  setuptools,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "colcon-override-check";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-override-check";
    tag = version;
    hash = "sha256-5ypJjC11ypfh9p/s1RBYHQuSXVTFyZaZVyR/jj+r4zw=";
  };
  build-system = [ setuptools ];

  dependencies = [
    colcon
    colcon-installed-package-information
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
    "colcon_override_check"
  ];

  meta = {
    description = "Extension for colcon-core to check for potential problems when overriding installed packages";
    homepage = "http://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-override-check";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
