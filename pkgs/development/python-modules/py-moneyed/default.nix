{
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-moneyed";
  version = "3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-moneyed";
    repo = "py-moneyed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k0ZbLwog6TYxKDLZV7eH1Br8buMPfpOkgp+pMN/qdB8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # babel has more currencies than defined in the package
    "test_all_babel_currencies"
  ];

  pythonImportsCheck = [ "moneyed" ];

  meta = {
    description = "Provides Currency and Money classes for use in your Python code";
    homepage = "https://github.com/py-moneyed/py-moneyed";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kurogeek ];
    changelog = "https://github.com/py-moneyed/py-moneyed/blob/${finalAttrs.src.tag}/CHANGES.rst";
  };
})
