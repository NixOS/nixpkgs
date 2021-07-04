{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.7";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc18d87f66e0b5da84fa731389496cfe18e4c21304e8f6713556b2e8724a7a4";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ python-dateutil pytz ];

  meta = with lib; {
    description = "A parser/generator of iCalendar files";
    homepage = "https://icalendar.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
