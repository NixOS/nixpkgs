{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  beartype,
  rich,
  typing-extensions,
  ipython,
  numpy,
  pytestCheckHook,
  sybil,
}:

buildPythonPackage (finalAttrs: {
  pname = "plum-dispatch";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beartype";
    repo = "plum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+skkKcYGnba7dRE3j8E701B17CnMaRkRf6P8hm0HWZM=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    beartype
    rich
    typing-extensions
  ];

  pythonImportsCheck = [ "plum" ];

  nativeCheckInputs = [
    ipython
    numpy
    pytestCheckHook
    sybil
  ];

  disabledTestPaths = [
    # Flaky because test helper assert_cache_performance is sensitive to execution time
    "tests/test_cache.py"
  ];

  meta = {
    description = "Multiple dispatch in Python";
    homepage = "https://github.com/beartype/plum";
    changelog = "https://github.com/beartype/plum/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
