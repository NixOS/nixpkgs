{ lib
, buildPythonPackage
, fetchPypi
, colorama
, docopt
, pytest
, watchdog
}:

buildPythonPackage rec {

  pname = "pytest-watch";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fflnd3varpqy8yzcs451n8h7wmjyx1408qdin5p2qdksl1ny4q6";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ colorama docopt watchdog ];

  meta = with lib; {
    description = "A zero-config CLI tool that runs pytest on file change";
    homepage    = https://github.com/joeyespo/pytest-watch;
    license     = licenses.mit;
    maintainers = with maintainers; [ sveitser ];
  };
}
