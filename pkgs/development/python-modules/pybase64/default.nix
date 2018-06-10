{ buildPythonPackage, stdenv, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c974bff394e16817596fab686a0c7deb4995a468b035b02a788b6dbfd1e6bdeb";
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
