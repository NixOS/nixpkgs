{ buildPythonPackage, stdenv, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b26263fb6aff11b1e62965c3bac205c4ebe147f37c213191384acafea7f8ab50";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pybase64;
    description = "Fast Base64 encoding/decoding";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ma27 ];
  };
}
