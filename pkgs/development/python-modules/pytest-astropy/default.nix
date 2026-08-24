{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytest,
  pytest-arraydiff,
  pytest-astropy-header,
  pytest-cov,
  pytest-doctestplus,
  pytest-filter-subpackage,
  pytest-mock,
  pytest-remotedata,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C9/x+menhW7Imcb3gQqGkRJT12IBowgi1+TvFLZxvcA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    hypothesis
    pytest-arraydiff
    pytest-astropy-header
    pytest-cov
    pytest-doctestplus
    pytest-filter-subpackage
    pytest-mock
    pytest-remotedata
  ];

  # pytest-astropy is a meta package that only propagates requirements
  doCheck = false;

  meta = {
    changelog = "https://github.com/astropy/pytest-astropy/releases/tag/v${version}";
    description = "Meta-package containing dependencies for testing";
    homepage = "https://github.com/astropy/pytest-astropy";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
