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
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocUtils";
    tag = "${version}";
<<<<<<< HEAD
    hash = "sha256-fomRB/qozB6QUCe2n4tzIFZOufchcjFUGOlApUR/KRo=";
=======
    hash = "sha256-4LzXBP/cp+nqIOM5QZIa1QptkSfv3fqdACHEHjJUtsw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
