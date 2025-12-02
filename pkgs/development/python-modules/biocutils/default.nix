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
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocUtils";
    tag = "${version}";
    hash = "sha256-4LzXBP/cp+nqIOM5QZIa1QptkSfv3fqdACHEHjJUtsw=";
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
