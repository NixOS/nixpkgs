{ buildPythonPackage, isPy3k, stdenv, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.0.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c430b36751dd89820c867aadd0130bbe8ce007ee570cbe91bb23012fb6f52e87";
  };

  requiredPythonModules = [ six ];
  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/pybase64";
    description = "Fast Base64 encoding/decoding";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ma27 ];
  };
}
