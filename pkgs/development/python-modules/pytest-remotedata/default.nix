{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pytest-remotedata";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ee2212818d89653132a7ffea0fb219eb2b00ecabc43f4d84f12e1fdf4853234";
  };

  propagatedBuildInputs = [ six pytest ];

  # network access
  doCheck = false;

  meta = with lib; {
    description = "Pytest plugin for controlling remote data access";
    homepage = https://github.com/astropy/pytest-remotedata;
    license = licenses.bsd3;
  };
}
