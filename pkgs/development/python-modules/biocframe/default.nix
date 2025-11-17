{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
  biocutils,
  numpy,
  polars,
  pandas,
}:

buildPythonPackage rec {
  pname = "biocframe";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocFrame";
    tag = "${version}";
    hash = "sha256-HeXQEVDGrr/oEGqLcKgq2RLDA58sbYtc2O6oEdFxrIw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    biocutils
    numpy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pandas
    polars
  ];

  pythonImportsCheck = [ "biocframe" ];

  meta = {
    description = "Bioconductor-like data frames";
    homepage = "https://github.com/BiocPy/BiocFrame";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
