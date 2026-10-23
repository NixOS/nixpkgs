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
    hash = "sha256-JbqAOv3k8171Q6YJFc7S5jSSYjUGTfcXw8s+Tj60Zww=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    unidecode
  ];
  nativeCheckInputs = [ pytest8_3CheckHook ];

  meta = {
    description = "Assertion library for Python";
    homepage = "http://heynemann.github.io/preggy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
