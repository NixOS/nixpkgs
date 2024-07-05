{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  hypothesis,
  pytest,
  pytest-arraydiff,
  pytest-astropy-header,
  pytest-cov,
  pytest-doctestplus,
  pytest-filter-subpackage,
  pytest-mock,
  pytest-openfiles,
  pytest-remotedata,
  setuptools,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tq6qme2RFj7Y+arBMscKgfJbxMEvPNVNujKfwmxnObU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    attrs
    hypothesis
    pytest-arraydiff
    pytest-astropy-header
    pytest-cov
    pytest-doctestplus
    pytest-filter-subpackage
    pytest-mock
    pytest-openfiles
    pytest-remotedata
  ];

  # pytest-astropy is a meta package that only propagates requirements
  doCheck = false;

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
