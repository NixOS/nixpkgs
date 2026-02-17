{
  lib,
  buildPythonPackage,
  exceptiongroup,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CFtkkGjFjvM4WsYz08nmik61eM5S71GT+Rh+nI8mZ1k=";
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
