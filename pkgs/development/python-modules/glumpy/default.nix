{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  #pytestCheckHook,
  setuptools,
  cython,
  freetype,
  numpy,
  pyopengl,
  triangle,
}:

buildPythonPackage rec {
  pname = "glumpy";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glumpy";
    repo = "glumpy";
    rev = "v${version}";
    hash = "sha256-SX1px2vsv2tkq1Uu5KWml60LtC1/zHN6hephU1mDYYs=";
  };

  postPatch = ''
    # don't fetch dependencies at build time
    substituteInPlace setup.py --replace-fail \
      "dist.Distribution().fetch_build_eggs(['Cython>=0.15.1', 'numpy>=1.20'])" \
      ""

    # provide path to libfreetype.so.6
    substituteInPlace glumpy/ext/freetype/__init__.py --replace-fail \
      "ctypes.util.find_library('freetype')" \
      "'${lib.getLib freetype}/lib/libfreetype.so.6'"
  '';

  propagatedBuildInputs = [
    freetype
  ];

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
    pyopengl
    triangle
  ];

  # TODO:
  # > ================== 60 failed, 57 passed, 33 warnings in 1.21s ==================
  #nativeCheckInputs = [
    #pytestCheckHook
  #];
  #pytestFlagsArray = [
    ## Import Error. This is probably fixable.
    #"--ignore=glumpy/gloo/tests/test_buffer.py"
  #];
  pythonImportsCheck = [
    "glumpy"
  ];

  meta = {
    description = "Python+Numpy+OpenGL: fast, scalable and beautiful scientific visualization";
    homepage = "https://github.com/glumpy/glumpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
