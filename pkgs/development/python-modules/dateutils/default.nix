{ lib, buildPythonPackage, fetchPypi, python-dateutil, pytz }:

buildPythonPackage rec {
  pname = "dateutils";
  version = "0.6.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A92QvLIVQb1OtLATY35PG1+USIHEbMbktnpgWeNw4/E=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "dateutils" ];

  meta = with lib; {
    description = "Utilities for working with datetime objects.";
    homepage = "https://github.com/jmcantrell/python-dateutils";
    license = licenses.bsd0;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
