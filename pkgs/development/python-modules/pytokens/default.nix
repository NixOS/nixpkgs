{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ast-serialize,
  mypy,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytokens";
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "pytokens";
    tag = finalAttrs.version;
    hash = "sha256-DOCOoZ3T7qh8me1vn7qYlEMiyc31d77sf1/5RsW5sUg=";
  };

  build-system = [
    ast-serialize
    mypy
    setuptools
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytokens"
  ];

  meta = {
    changelog = "https://github.com/tusharsadhwani/pytokens/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast, spec compliant Python 3.14+ tokenizer that runs on older Pythons";
    homepage = "https://github.com/tusharsadhwani/pytokens";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
