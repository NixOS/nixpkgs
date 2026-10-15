{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  numpy,
  numba,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "numpy-groupies";
  version = "0.12.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ml31415";
    repo = "numpy-groupies";
    tag = "v${finalAttrs.version}";
    hash = "sha256-18BarAUWq2ith7nB/o9oqi7zCH5pRY2nSY9go7I2AiA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    numba
    pandas
  ];

  pythonImportsCheck = [ "numpy_groupies" ];

  meta = {
    homepage = "https://github.com/ml31415/numpy-groupies";
    changelog = "https://github.com/ml31415/numpy-groupies/releases/tag/${finalAttrs.version}";
    description = "Optimised tools for group-indexing operations: aggregated sum and more";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ berquist ];
  };
})
