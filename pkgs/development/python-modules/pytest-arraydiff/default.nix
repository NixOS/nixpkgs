{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, pytest
, astropy
}:

buildPythonPackage rec {
  pname = "pytest-arraydiff";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de2d62f53ecc107ed754d70d562adfa7573677a263216a7f19aa332f20dc6c15";
  };

  propagatedBuildInputs = [
    numpy
    six
    pytest
  ];

  checkInputs = [
    pytest
    astropy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = https://github.com/astrofrog/pytest-arraydiff;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
