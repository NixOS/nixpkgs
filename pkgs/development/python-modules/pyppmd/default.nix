{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  coverage,
  hypothesis,
  pytest-benchmark,
  pytest-cov,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HTjOLkt+uEtTvIpSOAuU9mumw5MouIALMMK1vzFpOXM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    coverage
    hypothesis
    pytest-benchmark
    pytest-cov
    pytest-timeout
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/miurahr/d";
    description = "Implementation of the PPM compression algorithm";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
