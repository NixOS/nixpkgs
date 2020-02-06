{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.4";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16gjvqv0n05jrb9g228pdjgzd3amz2pdhvcgsn1jypszjg5m2w9l";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ dateutil pytz ];

  meta = with stdenv.lib; {
    description = "A parser/generator of iCalendar files";
    homepage = "https://icalendar.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
