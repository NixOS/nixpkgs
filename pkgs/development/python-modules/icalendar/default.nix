{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l0i3wC78xD5Y0GFa4JdqxPJl6Q2t7ptPiE3imQXBs5U=";
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
