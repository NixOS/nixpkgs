{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "floret";
  version = "0.10.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "floret";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7vkw6H0ZQoHEwNusY6QWh/vPbSCdP1ZaaqABHsZH6hQ=";
  };

  patches = [ ./cstdint.patch ];

  build-system = [
    pybind11
    setuptools
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "floret" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Compares trained vectors against hardcoded values (toolchain-dependent)
    # AssertionError: Arrays are not almost equal to 7 decimals
    "test_train_unsupervised_fasttext"
  ];

  meta = {
    description = "FastText + Bloom embeddings for compact, full-coverage vectors with spaCy";
    homepage = "https://github.com/explosion/floret";
    changelog = "https://github.com/explosion/floret/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
