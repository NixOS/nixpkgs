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

buildPythonPackage rec {
  pname = "numpy-groupies";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml31415";
    repo = "numpy-groupies";
    tag = "v${version}";
    hash = "sha256-khakvBpCmxEv1Jwrs1XA/pW5Zix9Ya3RygLCEQDaa28=";
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
    changelog = "https://github.com/ml31415/numpy-groupies/releases/tag/${src.tag}";
    description = "Optimised tools for group-indexing operations: aggregated sum and more";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ berquist ];
  };
}
