{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "parso";
  version = "0.8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "parso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vpWoxLIvNt4QQh/r57iAvX3Zebet3mihb5efOWLhYI8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.15") [
    # Expected exception mismatches
    "test_python_exception_matches"
  ];

  meta = {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
})
