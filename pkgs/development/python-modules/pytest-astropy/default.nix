{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytest
, pytest-astropy-header
, pytest-doctestplus
, pytest-filter-subpackage
, pytest-remotedata
, pytest-openfiles
, pytest-arraydiff
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.9.0";
  disabled = pythonOlder "3.6";

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
    pytest-astropy-header
    pytest-doctestplus
    pytest-filter-subpackage
    pytest-remotedata
    pytest-openfiles
    pytest-arraydiff
  ];

  # pytest-astropy is a meta package and has no tests
  #doCheck = false;
  checkPhase = ''
    # 'doCheck = false;' still invokes the pytestCheckPhase which makes the build fail
  '';

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
