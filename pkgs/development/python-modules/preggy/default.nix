{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  unidecode,
  pytest8_3CheckHook,
}:

buildPythonPackage rec {
  pname = "preggy";
  version = "1.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "25ba803afde4f35ef543a60915ced2e634926235064df717c3cb3e4e3eb4670c";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    unidecode
  ];
  nativeCheckInputs = [ pytest8_3CheckHook ];

  meta = with lib; {
    description = "Assertion library for Python";
    homepage = "http://heynemann.github.io/preggy/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
