{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "osrf-pycommon";
  version = "2.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osrf";
    repo = "osrf_pycommon";
    tag = finalAttrs.version;
    hash = "sha256-gKYeCvcJDJkW2OYP7K3eyztuPSkzE8dHoTUh4sKvxcM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "osrf_pycommon" ];

  disabledTestPaths = [
    "tests/test_code_format.py" # flake8 based tests don't work
  ];

  meta = {
    description = "Commonly needed Python modules used by Python software developed at OSRF";
    homepage = "http://osrf-pycommon.readthedocs.org/";
    changelog = "https://github.com/osrf/osrf_pycommon/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    downloadPage = "https://github.com/osrf/osrf_pycommon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
