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
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "619800eb2cbf64548fbea25268efe7c6f6ae206cb4825f34abd36f27bcf946a2";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    hypothesis
    pytest
    pytest-astropy-header
    pytest-doctestplus
    pytest-filter-subpackage
    pytest-remotedata
    pytest-openfiles
    pytest-arraydiff
  ];

  # pytest-astropy is a meta package and has no tests
  checkPhase = ":";

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
