{ buildPythonPackage, isPy3k, lib, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.1.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0e0db1dee2a2cbf35e6710ea138594ecc1e0f491ff9103f136de83d8f159315";
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
