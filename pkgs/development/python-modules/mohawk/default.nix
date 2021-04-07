{ lib, buildPythonPackage, fetchPypi, python, mock, nose, pytest, six }:

with lib;
buildPythonPackage rec {
  pname = "mohawk";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08wppsv65yd0gdxy5zwq37yp6jmxakfz4a2yx5wwq2d222my786j";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ mock nose pytest ];

  checkPhase = ''
    pytest mohawk/tests.py
  '';

  meta = {
    description = "Python library for Hawk HTTP authorization.";
    homepage = "https://github.com/kumar303/mohawk";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
