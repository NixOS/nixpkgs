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
  version = "3.0.1";
  pname = "oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ce32c5d989a1827e3f1148f98b9085ed2370fc939bf524c9c851d8714797298";
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
