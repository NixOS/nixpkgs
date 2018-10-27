{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "3.9.0";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93d0b94eab23d08f62962542309916a9681f16de3d5eca1c75497f30f1b07792";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ dateutil pytz ];

  meta = with stdenv.lib; {
    description = "A parser/generator of iCalendar files";
    homepage = "http://icalendar.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
