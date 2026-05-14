{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "interegular";
  version = "0.3.3";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2baXshs0iEcROZug8DdpFLgYmc5nADJIbQ0Eg0SnZgA=";
  };

  pythonImportsCheck = [ "interegular" ];

  meta = {
    description = "Library to check a subset of python regexes for intersections";
    homepage = "https://github.com/MegaIng/interegular";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lach ];
  };
}
