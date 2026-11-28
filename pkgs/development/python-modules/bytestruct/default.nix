{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "bytestruct";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "bytestruct";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uc1RlBgVQ0PZYDHhm1QsWME/7qdFeixKUoDQUpV0H1k=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "bytestruct" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/doronz88/bytestruct/releases/tag/${finalAttrs.src.tag}";
    description = "Typed, dependency-free binary records and codecs on top of struct";
    homepage = "https://github.com/doronz88/bytestruct";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
