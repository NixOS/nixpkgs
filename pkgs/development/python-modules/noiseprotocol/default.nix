{ stdenv
, buildPythonPackage
, lib
, pytest
, scapy
, cryptography
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "noiseprotocol";
  version = "0.3.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "plizonczyk";
    repo = "noiseprotocol";
    rev = "73375448c55af85df0230841af868b7f31942f0a";
    sha256 = "1mk0rqpjifdv3v1cjwkdnjbrfmzzjm9f3qqs1r8vii4j2wvhm6am";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  buildInputs = [ scapy ];
  propagatedBuildInputs = [ cryptography ];

  meta = with stdenv.lib; {
    description = "Python Implementation of Noise Protocol Framework";
    homepage = "https://github.com/plizonczyk/noiseprotocol";
    license = licenses.mit;
    maintainers = with maintainers; [ reardencode ];
  };
}
