{ lib
, buildPythonPackage
, fetchPypi
, mock
}:
 
buildPythonPackage rec {
  pname = "python_http_client";
  version = "3.2.4"; 
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "1ncsvhb6sms2ahr737jmz1gq9ppn8yprj9v1awlnh8ylqg2scnq2";
  };
 
 propagatedBuildInputs = [ mock ];
 
  meta = with lib; {
    description = "Twilio SendGrid Quickly and easily access any RESTful or RESTful-like API";
    homepage = https://pypi.org/project/python-http-client/;
    license = licenses.mit;
    maintainers = with maintainers; [ xfoxawy ];
  };
}