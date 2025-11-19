{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "rakopy";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gl9PsOSMhei2gVVDgJzoaqDT5l/4fP7fM+ANjUInqvw=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "rakopy" ];

  meta = {
    description = "Python library that allows you to control Rako Controls system programmatically";
    homepage = "https://github.com/princekama/rakopy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ graham33 ];
  };
}