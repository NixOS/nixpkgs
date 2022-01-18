{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.9";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc73fa9c848744843046228cb66ea86cd8c18d73a51b140f7c003f760b84a997";
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
