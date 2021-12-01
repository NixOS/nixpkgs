{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytest
, pytest-arraydiff
, pytest-astropy-header
, pytest-doctestplus
, pytest-filter-subpackage
, pytest-mock
, pytest-openfiles
, pytest-remotedata
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.9.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cdac1b2a5460f37477a329712c3a5d4af4ddf876b064731995663621be4308b";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    hypothesis
    pytest-arraydiff
    pytest-astropy-header
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
    maintainers = with maintainers; [ costrouc ];
  };
}
