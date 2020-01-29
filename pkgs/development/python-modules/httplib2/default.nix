{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5f914f18f99cb9541660454a159e3b3c63241fc3ab60005bb88d97cc7a4fb58";
  };

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/httplib2/httplib2";
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
