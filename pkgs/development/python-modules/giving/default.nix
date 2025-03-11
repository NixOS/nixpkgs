{
  lib,
  buildPythonPackage,
  fetchPypi,
  asttokens,
  hatchling,
  reactivex,
  varname,
}:

buildPythonPackage rec {
  pname = "giving";
  version = "0.4.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M3J/sFJfXZJyV8aOewJFx4n567nOY+QgwG5Aa+8KxsI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asttokens
    reactivex
    varname
  ];

  pythonImportsCheck = [ "giving" ];

  meta = {
    description = "Reactive logging";
    homepage = "https://github.com/breuleux/giving";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
