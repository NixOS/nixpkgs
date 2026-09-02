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

buildPythonPackage (finalAttrs: {
  pname = "biocutils";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BiocPy";
    repo = "BiocUtils";
    tag = finalAttrs.version;
    hash = "sha256-B8kt2rTya/kiSPSY8Xeo6dOdSszUK76ySaqLlJ7kFQk=";
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
    changelog = "https://github.com/BiocPy/biocutils/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
})
