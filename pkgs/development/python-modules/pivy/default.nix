{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.6.10";
  format = "other";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "pivy";
    tag = version;
    hash = "sha256-DRA4NTAHg2iB/D1CU9pJEpsZwX9GW3X5gpxbIwP54Ko=";
  };

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
    maintainers = with lib.maintainers; [ ];
  };
}
