{
  lib,
  buildPythonPackage,
  exceptiongroup,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dvpiw6DRQczT5Tcj81II1cdZAIPbcWTIENLP/QQprpI=";
  };

  build-system = [ poetry-core ];

  dependencies = [ exceptiongroup ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    homepage = "https://github.com/gaphor/generic";
    changelog = "https://github.com/gaphor/generic/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
