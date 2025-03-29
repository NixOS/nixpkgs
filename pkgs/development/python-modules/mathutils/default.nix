{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonAtLeast,

  # build-system
  setuptools,
}:

buildPythonPackage {
  pname = "mathutils";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ideasman42";
    repo = "blender-mathutils";
    rev = "d63d623a9e580a567eb6acb7dbed7cad0e4f8c28";
    hash = "sha256-c28kt2ADw4wHNLN0CBPcJU/kqm6g679QRaICk4WwaBc=";
  };

  # error: implicit declaration of function ‘_PyLong_AsInt’; did you mean ‘PyLong_AsInt’? [-Wimplicit-function-declaration]
  # https://github.com/python/cpython/issues/108444
  postPatch = lib.optionalString (pythonAtLeast "3.13") ''
    substituteInPlace src/generic/py_capi_utils.{c,h} \
      --replace-fail "_PyLong_AsInt" "PyLong_AsInt"
  '';

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "mathutils" ];

  meta = {
    description = "General math utilities library providing Matrix, Vector, Quaternion, Euler and Color classes, written in C for speed";
    homepage = "https://gitlab.com/ideasman42/blender-mathutils";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ autra ];
  };
}
