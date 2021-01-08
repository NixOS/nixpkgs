{ lib, fetchPypi, buildPythonPackage, colorama, spinners }:

buildPythonPackage rec {
  pname = "halo";
  version = "0.0.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2ejUh7pHVO3FS1O40UoEeHSpjIZdRN3Yus9cAY8ydY=";
  };

  propagatedBuildInputs = [ colorama spinners ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  meta = with lib; {
    description = "Python API for Paperspace Cloud";
    homepage    = "https://paperspace.com";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
