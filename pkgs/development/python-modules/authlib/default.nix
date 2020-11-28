{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, cryptography
, requests
}:

buildPythonPackage rec {
  version = "0.15.1";
  pname = "authlib";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "v${version}";
    sha256 = "0jh4kdi5spzhmgvq3ffz2q467hjycz3wg97f7n53rffiwd86jrh5";
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
