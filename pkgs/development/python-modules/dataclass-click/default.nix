{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dataclass-click";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "dataclass_click";
    inherit version;
    hash = "sha256-EOfeY43Z5orpq9UIb2HY3e5CsYc6cPX9n9IWeFavrBE=";
  };

  build-system = [ poetry-core ];

  dependencies = [ click ];

  doCheck = false;

  pythonImportsCheck = [ "dataclass_click" ];

  meta = {
    description = "Use PEP 593 annotations to define Click options and arguments";
    homepage = "https://github.com/couling/dataclass-click";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bdim404 ];
  };
}
