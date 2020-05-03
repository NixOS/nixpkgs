{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.5";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14ynjj65kfmlcvpb7k097w789wvxncd3cr3xz5m1jz9yl9v6vv5q";
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
