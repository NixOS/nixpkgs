{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  packaging,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-package-information";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-package-information";
    tag = version;
    hash = "sha256-BnDrnIgzXrNAPIg7sr8CcaVdisplJdAvjyZ28r4o/wI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    packaging
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_package_information"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to output package information";
    homepage = "http://colcon.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
