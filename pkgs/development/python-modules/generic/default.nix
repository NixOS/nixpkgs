{
  lib,
  buildPythonPackage,
  exceptiongroup,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0U2uZihULrCEQ0WI01B1bIjy8wx+I0itX8+gH723zu0=";
  };

  build-system = [ poetry-core ];

  dependencies = [ exceptiongroup ];

  pythonImportsCheck = [ "generic" ];

  meta = {
    description = "Generic programming (Multiple dispatch) library for Python";
    homepage = "https://github.com/gaphor/generic";
    changelog = "https://github.com/gaphor/generic/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
