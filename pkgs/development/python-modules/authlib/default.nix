{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, cryptography
, requests
}:

buildPythonPackage rec {
  version = "0.15.4";
  pname = "authlib";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "v${version}";
    sha256 = "1jc7rssi1y6brkwjplj8qmi4q5w9h9wz03fbhg01c0y5bmy0g1nj";
  };

  propagatedBuildInputs = [ cryptography requests ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    PYTHONPATH=$PWD:$PYTHONPATH pytest tests/{core,files}
  '';

  meta = with lib; {
    homepage = "https://github.com/lepture/authlib";
    description = "The ultimate Python library in building OAuth and OpenID Connect servers. JWS,JWE,JWK,JWA,JWT included.";
    maintainers = with maintainers; [ flokli ];
    license = licenses.bsd3;
  };
}
