{ buildPythonPackage, isPy3k, lib, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e310fcf5cfa2cbf7d1d7eb503b6066bec785216bcd1d8c0a736f59d5ec21b0b";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/pybase64";
    description = "Fast Base64 encoding/decoding";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ma27 ];
  };
}
