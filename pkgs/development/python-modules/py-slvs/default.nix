{
  lib,
  buildPythonPackage,
  fetchPypi,
  swig,
  cmake,
  ninja,
  setuptools,
  scikit-build,
}:

buildPythonPackage rec {
  pname = "py-slvs";
  version = "1.0.6";

  src = fetchPypi {
    pname = "py_slvs";
    inherit version;
    hash = "sha256-U6T/aXy0JTC1ptL5oBmch0ytSPmIkRA8XOi31NpArnI=";
  };

  pyproject = true;

  nativeBuildInputs = [
    swig
  ];

  build-system = [
    cmake
    ninja
    setuptools
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "py_slvs"
  ];

  meta = {
    description = "Python binding of SOLVESPACE geometry constraint solver";
    homepage = "https://github.com/realthunder/slvs_py";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      traverseda
    ];
  };
}

