{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  swig,
  cmake,
  coin3d,
  soqt,
  libGLU,
}:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "pivy";
    tag = version;
    hash = "sha256-DRA4NTAHg2iB/D1CU9pJEpsZwX9GW3X5gpxbIwP54Ko=";
  };

  # https://github.com/coin3d/pivy/pull/138
  # FindThreads only works if either C or CXX language is enabled
  postPatch = ''
    substituteInPlace distutils_cmake/CMakeLists.txt \
      --replace-fail 'project(pivy_cmake_setup NONE)' 'project(pivy_cmake_setup CXX)'
  '';

  build-system = [ setuptools ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    swig
    cmake
  ];

  buildInputs = [
    coin3d
    soqt
    libGLU # dummy buildInput that provides missing header <GL/glu.h>
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
