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
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocFrame";
    tag = version;
    hash = "sha256-NycHzlOdDRyXvpZLWDr7mg5eXxrBjsSk16AUHpQrDN0=";
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
