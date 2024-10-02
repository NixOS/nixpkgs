{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pip,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "extension-helpers";
    rev = "refs/tags/v${version}";
    hash = "sha256-pYCSLb6uuQ9ZtMZOQH0DxLlfgFv3tgH+AL35IN71cNI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pytestCheckHook
    pip
  ];

  pythonImportsCheck = [ "extension_helpers" ];

  pytestFlagsArray = [ "extension_helpers/tests" ];

  disabledTests = [
    # Test require network access
    "test_only_pyproject"
  ];

  meta = with lib; {
    description = "Helpers to assist with building Python packages with compiled C/Cython extensions";
    homepage = "https://github.com/astropy/extension-helpers";
    changelog = "https://github.com/astropy/extension-helpers/blob/${version}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
