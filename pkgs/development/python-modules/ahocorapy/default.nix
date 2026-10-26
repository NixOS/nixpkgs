{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ahocorapy";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abusix";
    repo = "ahocorapy";
    tag = finalAttrs.version;
    hash = "sha256-mRSWkWCHjdSq9Rxj+GuflTBHEDRQCBMnKsb6LcbJudo=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "ahocorapy" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/ahocorapy_test.py"
  ];

  meta = {
    changelog = "https://github.com/abusix/ahocorapy/blob/${finalAttrs.src.tag}/CHANGELOG";
    description = "Pure python Aho-Corasick library";
    homepage = "https://github.com/abusix/ahocorapy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
