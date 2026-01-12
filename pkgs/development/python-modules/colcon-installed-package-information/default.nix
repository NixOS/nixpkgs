{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  colcon,
  importlib-metadata,
  # tests
  pytestCheckHook,
  pytest-cov-stub,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-installed-package-information";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-installed-package-information";
    tag = version;
    hash = "sha256-7PjLWLwX5QwxWCN1iWOGB3cyArjnxQKT5BHmukj0MII=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [ "colcon_installed_package_information" ];

  meta = {
    description = "Extensions for colcon to inspect packages which have already been installed";
    homepage = "https://colcon.readthedocs.io/en/released/";
    downloadPage = "https://github.com/colcon/colcon-installed-package-information";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
