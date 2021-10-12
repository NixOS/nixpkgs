{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.8";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7508a92b4e36049777640b0ae393e7219a16488d852841a0e57b44fe51d9f848";
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
