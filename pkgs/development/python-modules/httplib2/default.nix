{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pyb0hmc0j0kcy27yiw38gq9pk7f1fkny5k1vd13cdz6l3csw7g7";
  };

  meta = with lib; {
    homepage = http://code.google.com/p/httplib2;
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
