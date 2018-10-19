{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
}:

buildPythonPackage rec {
  pname = "akismet";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a5fxy2dv4pj7bnjh9rjqk9zzygjgr00f03ry8pvddghjrc18f7h";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
  ];

  doCheck = false; # requires API keys and online access

  meta = with lib; {
    description = "Python interface to the Akismet spam-filtering API";
    homepage = https://github.com/ubernostrum/akismet;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
