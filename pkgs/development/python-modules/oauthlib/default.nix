{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pytest
, cryptography
, blinker
, pyjwt
}:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4d99ae8ccfb7d33ba9591b59355c64eef5241534aa3da2e4c0435346b84bc8e";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ cryptography blinker pyjwt ];

  checkPhase = ''
    py.test tests/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/idan/oauthlib;
    description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    maintainers = with maintainers; [ prikhi ];
    license = licenses.bsd3;
  };
}
