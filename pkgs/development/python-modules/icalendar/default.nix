{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  version = "5.0.4";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8KqG1vW8EQ7TuR6WxIxwNR16CfvtJTZvZz3At5nIOXU=";
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
