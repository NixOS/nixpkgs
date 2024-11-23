{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "array-api-strict";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-strict";
    rev = "refs/tags/${version}";
    hash = "sha256-9WIKN2mekJIOD076946xkNqMlfeTaLuuB9qqAJN8Xwc=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "array_api_strict" ];

  disabledTests = [
    "test_disabled_extensions"
    "test_environment_variables"
  ];

  meta = {
    homepage = "https://data-apis.org/array-api-strict";
    changelog = "https://github.com/data-apis/array-api-strict/releases/tag/${version}";
    description = "A strict, minimal implementation of the Python array API";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ berquist ];
  };
}
