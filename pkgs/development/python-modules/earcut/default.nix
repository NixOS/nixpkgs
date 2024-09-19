{
  lib,
  numpy,
  fetchPypi,
  setuptools,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "earcut";
  version = "1.1.5";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IcVbAy/guQZY5/MF4e5AjLT3Z4LFBm2GJzrftLbMI+A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "earcut" ];

  meta = with lib; {
    description = "A pure Python port of the earcut JS triangulation library";
    homepage = "https://pypi.org/project/earcut/";
    license = licenses.isc;
    maintainers = with maintainers; teams.geospatial.members ++ [ mapperfr ];
    mainProgram = "earcut";
  };
}
