{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, cryptography
, requests
}:

buildPythonPackage rec {
  version = "0.14.1";
  pname = "authlib";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "v${version}";
    sha256 = "0z56r5s8z8pfp0p8zrf1chgzan4q25zg0awgc7bgkvkwgxbhzx4m";
  };

  propagatedBuildInputs = [ cryptography requests ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    PYTHONPATH=$PWD:$PYTHONPATH pytest tests/{core,files}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/lepture/authlib";
    description = "The ultimate Python library in building OAuth and OpenID Connect servers. JWS,JWE,JWK,JWA,JWT included.";
    maintainers = with maintainers; [ flokli ];
    license = licenses.bsd3;
  };
}
