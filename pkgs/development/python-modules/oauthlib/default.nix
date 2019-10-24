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
  version = "3.1.0";
  pname = "oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889";
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
