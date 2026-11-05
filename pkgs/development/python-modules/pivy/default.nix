{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python,
  pythonRecompileBytecodeHook,
  swig,
  cmake,
  coin3d,
  soqt,
  libGLU,
}:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.11";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "pivy";
    tag = version;
    hash = "sha256-jBc7+hoG1x7KDYPbexPRwnll9qz4qA3Y1w7A7DuES2Y=";
  };

  patches = [
    # Fix build against SWIG >= 4.5
    # https://github.com/FreeCAD/pivy/pull/8
    (fetchpatch {
      name = "swig-4.5-compat";
      url = "https://github.com/FreeCAD/pivy/commit/c42d938aec005efda5f0ff114298d7ecb0a494b8.patch";
      excludes = [ "interfaces/CMakeLists.txt" ];
      hash = "sha256-Ox+qbmmJA1cBJ7J3LhzFuAwh0q3s2gZPCUKZr/W3cwg=";
    })
  ];

  nativeBuildInputs = [
    swig
    cmake
    pythonRecompileBytecodeHook
  ];

  buildInputs = [
    coin3d
    soqt
    libGLU # dummy buildInput that provides missing header <GL/glu.h>
  ];

  cmakeFlags = [
    (lib.cmakeBool "PIVY_USE_QT6" true)
    (lib.cmakeFeature "PIVY_Python_SITEARCH" "${placeholder "out"}/${python.sitePackages}")
  ];

  dontWrapQtApps = true;

  pythonImportsCheck = [ "pivy" ];

  meta = {
    homepage = "https://github.com/coin3d/pivy/";
    description = "Python binding for Coin";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
