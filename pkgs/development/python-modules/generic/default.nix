{
  lib,
  buildPythonPackage,
  exceptiongroup,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "generic";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CX2W0sre89jimW8+8/WK0wS1+w3GwVM4wxdWH/C7pJM=";
  };

  build-system = [ poetry-core ];

  dependencies = [ exceptiongroup ];

  pythonImportsCheck = [ "generic" ];

  meta = {
    description = "Generic programming (Multiple dispatch) library for Python";
    homepage = "https://github.com/gaphor/generic";
    changelog = "https://github.com/gaphor/generic/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
