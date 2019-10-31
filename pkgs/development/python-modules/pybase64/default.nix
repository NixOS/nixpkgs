{ buildPythonPackage, stdenv, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71a729b10232b38cba001e621dbaa6dbba2302dc44a93706295f1ff760f40876";
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
