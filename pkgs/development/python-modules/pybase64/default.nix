{ buildPythonPackage, stdenv, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d415057b17bd8acf65e7a2f5d25e468b5b39df3290c7d9dbb75c0785afbdf3cf";
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
