{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, cryptography
, requests
}:

buildPythonPackage rec {
  version = "0.15.5";
  pname = "authlib";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "v${version}";
    sha256 = "1893mkzrlfxpxrgv10y134y8c3ni5hb0qvb0wsc76d2k4mci5j3n";
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
