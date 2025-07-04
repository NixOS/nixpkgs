{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  unidecode,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "preggy";
  version = "1.4.4";
  format = "setuptools";

  propagatedBuildInputs = [
    six
    unidecode
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "25ba803afde4f35ef543a60915ced2e634926235064df717c3cb3e4e3eb4670c";
  };

  meta = with lib; {
    description = "Assertion library for Python";
    homepage = "http://heynemann.github.io/preggy/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
