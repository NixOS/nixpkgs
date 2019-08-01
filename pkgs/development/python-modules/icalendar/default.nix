{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.3";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mk3dk1dxkcm46jy48v27j2w2349iv4sbimqj1yb5js43mx49hh7";
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
