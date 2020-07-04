{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.6";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17wpvngxv9q333ng3hm4k1qhiafmzipr7l2liwny7ar24qiyfvvy";
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
