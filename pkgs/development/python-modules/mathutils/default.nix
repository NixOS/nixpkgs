{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "mathutils";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ideasman42";
    repo = "blender-mathutils";
    rev = "d63d623a9e580a567eb6acb7dbed7cad0e4f8c28";
    hash = "sha256-c28kt2ADw4wHNLN0CBPcJU/kqm6g679QRaICk4WwaBc=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "mathutils" ];

  meta = with lib; {
    description = "A general math utilities library providing Matrix, Vector, Quaternion, Euler and Color classes, written in C for speed";
    homepage = "https://gitlab.com/ideasman42/blender-mathutils";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ autra ];
  };
}
