{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
  scipy,
  pandas,
  numpy,
}:

buildPythonPackage rec {
  pname = "biocutils";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocUtils";
    tag = version;
    hash = "sha256-G7g+jjXoKtnp+d7a5NoEtVBEN5Di1P/pWjgiJJv6fHA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pandas
    scipy
  ];

  pythonImportsCheck = [ "biocutils" ];

  meta = {
    description = "Miscellaneous utilities for BiocPy, mostly to mimic base functionality in R";
    homepage = "https://github.com/BiocPy/BiocUtils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
