{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.52";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4947b75401245d3a69de698617bb81fcba1ed7fd56c15d339a5f3b2bbbc391f7";
  };

  # PyPI tarball does not include tests/ directory
  # Unreliable timing: https://github.com/danielperna84/pyhomematic/issues/126
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = https://github.com/danielperna84/pyhomematic;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
