{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  unidecode,
  nose,
  yanc,
}:

buildPythonPackage rec {
  pname = "preggy";
  version = "1.4.4";
  format = "setuptools";

  propagatedBuildInputs = [
    six
    unidecode
  ];
  nativeCheckInputs = [
    nose
    yanc
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "25ba803afde4f35ef543a60915ced2e634926235064df717c3cb3e4e3eb4670c";
  };

  checkPhase = ''
    nosetests .
  '';

  meta = with lib; {
    description = "Assertion library for Python";
    homepage = "http://heynemann.github.io/preggy/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
