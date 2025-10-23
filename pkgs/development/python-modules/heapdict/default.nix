{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "heapdict";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "HeapDict";
    inherit version;
    hash = "sha256-hJX1ez4D2ORtXxssxiyogayjkv1cwEjcCqLhptI+zbY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "heapdict" ];

  meta = with lib; {
    description = "Heap with decrease-key and increase-key operations";
    homepage = "https://github.com/DanielStutzbach/heapdict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
