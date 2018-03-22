{ buildPythonPackage, stdenv, fetchPypi, parameterized, six, nose }:

buildPythonPackage rec {
  pname = "pybase64";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hggg69s5r8jyqdwyzri5sn3f19p7ayl0fjhjma0qzgfp7bk6zjc";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ parameterized nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pybase64;
    description = "Fast Base64 encoding/decoding";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ma27 ];
  };
}
