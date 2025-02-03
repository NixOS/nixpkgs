{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  pybind11,
  scikit-build-core,
  numpy,
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "38";
  pyproject = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit version;
    hash = "sha256-l0SVah14fD0hXqE8WqG2EQnIk/Ad0e/i2mj1jt6K0Vs=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];

  dependencies = [ numpy ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward_cpp" ];

  meta = {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
