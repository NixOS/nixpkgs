{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  build,
  cython,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
  tomli,
  wheel,
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "extension-helpers";
    tag = "v${version}";
    hash = "sha256-coSgaPoz93CqJRb65xYs1sNOwoGhcxWGJF7Jc9N2W1I=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    build
    cython
    pytestCheckHook
    wheel
  ];

  pythonImportsCheck = [ "extension_helpers" ];

  enabledTestPaths = [ "extension_helpers/tests" ];

  disabledTests = [
    # Test require network access
    "test_only_pyproject"
    # ModuleNotFoundError
    "test_no_setup_py"
  ];

  meta = with lib; {
    description = "Helpers to assist with building Python packages with compiled C/Cython extensions";
    homepage = "https://github.com/astropy/extension-helpers";
    changelog = "https://github.com/astropy/extension-helpers/blob/${src.tag}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
