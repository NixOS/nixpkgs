{
  buildPythonPackage,
  coverage,
  fetchPypi,
  hypothesis,
  lib,
  nix-update-script,
  pythonOlder,
  pytest-cov,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x/W+9/R3I8U0ION3vGTSVThDvui8rF8K0HarFSR4ABg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    coverage
    hypothesis
    pytest-cov
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/miurahr/pybcj";
    description = "Branch-Call-Jump filter for Python";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
