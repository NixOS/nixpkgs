{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "merge3";
  version = "0.0.15";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0+rCE9hNVt/J45VSrIJGx4YKlAlk6+7YqL5EIvZJK68=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "merge3" ];

  meta = {
    description = "Python implementation of 3-way merge";
    mainProgram = "merge3";
    homepage = "https://github.com/breezy-team/merge3";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
