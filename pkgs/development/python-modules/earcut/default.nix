{
  lib,
  numpy,
  fetchFromGitHub,
  setuptools,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "earcut";
  version = "1.1.5";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "vojtatom";
    repo = "earcut.py";
    rev = "d8405873117a79b4c01128fed5cb7af3f3faa0a0";
    hash = "sha256-aRNY8I7hh7MMrGTQ7uIkeN2WNqezY2sSryZnATai7Vg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "earcut" ];

  meta = {
    description = "Pure Python port of the earcut JS triangulation library";
    homepage = "https://pypi.org/project/earcut/";
    license = licenses.isc;
    maintainers = with maintainers; teams.geospatial.members ++ [ mapperfr ];
    mainProgram = "earcut";
  };
}
