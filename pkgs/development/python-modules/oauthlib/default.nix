{ stdenv
, buildPythonPackage
, fetchFromGitHub
, mock
, pytest
, cryptography
, blinker
, pyjwt
}:

buildPythonPackage rec {
  pname = "oauthlib";
  version = "unstable-2020-05-08";

  # master supports pyjwt==1.7.1
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "46647402896db5f0d979eba9594623e889739060";
    sha256 = "1wrdjdvlfcd74lckcgascnasrffg8sip0z673si4ag5kv4afiz3l";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ cryptography blinker pyjwt ];

  checkPhase = ''
    py.test tests/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/idan/oauthlib";
    description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    maintainers = with maintainers; [ prikhi ];
    license = licenses.bsd3;
  };
}
