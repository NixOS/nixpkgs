{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "atomiclong";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yxN4xM1nbW8kNkHFDid1BKv0X3Dx6nbkRu/Nu2liS74=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [ cffi ];

  pythonImportsCheck = [ "atomiclong" ];

  meta = with lib; {
    description = "Long data type with atomic operations using CFFI";
    homepage = "https://github.com/dreid/atomiclong";
    license = licenses.mit;
    maintainers = with maintainers; [ robbinch ];
  };
}
