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
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml31415";
    repo = "numpy-groupies";
    rev = "refs/tags/v${version}";
    hash = "sha256-Eu+5SR28jIasKe1p7rvbq2yo3PGZRQWWdG3A5vGhnyM=";
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

  meta = with lib; {
    homepage = "https://github.com/ml31415/numpy-groupies";
    changelog = "https://github.com/ml31415/numpy-groupies/releases/tag/v${version}";
    description = "Optimised tools for group-indexing operations: aggregated sum and more";
    license = licenses.bsd2;
    maintainers = [ maintainers.berquist ];
  };
}
