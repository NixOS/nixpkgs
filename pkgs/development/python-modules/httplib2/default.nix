{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
}:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4NQo2tQ8ctvOfRY7d1P/x6OcCX5niO8Q9BmNtpuS8I4=";
  };

  propagatedBuildInputs = [ pyparsing ];

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/httplib2/httplib2";
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
