{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-doctestplus
, pytest-remotedata
, pytest-openfiles
, pytest-arraydiff
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f28fb81dcdfa745f423b8f6d0303d97357d775b4128bcc2b3668f1602fd5a0b";
  };

  propagatedBuildInputs = [
    pytest
    pytest-doctestplus
    pytest-remotedata
    pytest-openfiles
    pytest-arraydiff
  ];

  # pytest-astropy is a meta package and has no tests
  doCheck = false;

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = https://astropy.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
