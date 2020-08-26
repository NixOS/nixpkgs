{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3";
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
