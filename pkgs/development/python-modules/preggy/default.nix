{ stdenv, buildPythonPackage, fetchPypi, six, unidecode, nose, yanc }:

buildPythonPackage rec {
  pname = "preggy";
  version = "1.4.2";

  propagatedBuildInputs = [ six unidecode ];
  checkInputs = [ nose yanc ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g4ifjh01dkmdzs4621ahk8hpkngid1xxhl51jvzy4h4li4590hw";
  };

  checkPhase = ''
    nosetests .
  '';

  meta = with stdenv.lib; {
    description = "Assertion library for Python";
    homepage = http://heynemann.github.io/preggy/;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
