{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "array-api-strict";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-strict";
    tag = version;
    hash = "sha256-m0uWaeUwHsWyAOxS7nxY8c+HWUhz+mOKNE4M0DsiClI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 61.0,<=75" "setuptools"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

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
    changelog = "https://github.com/data-apis/array-api-strict/releases/tag/${src.tag}";
    description = "Strict, minimal implementation of the Python array API";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ berquist ];
  };
}
