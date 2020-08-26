{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, pytestCheckHook
, numpy
, astropy
}:

buildPythonPackage rec {
  pname = "pytest-astropy-header";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y87agr324p6x5gvhziymxjlw54pyn4gqnd49papbl941djpkp5g";
  };

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
    pytestcov
    numpy
    astropy
  ];

  meta = with lib; {
    description = "Plugin to add diagnostic information to the header of the test output";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
