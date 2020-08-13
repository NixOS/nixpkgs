{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, cryptography
, requests
}:

buildPythonPackage rec {
  version = "0.14.3";
  pname = "authlib";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "v${version}";
    sha256 = "0ph97j94i40jj7nc5ya8pfq0ccx023zbqpcs5hrxmib53g64k5xy";
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
