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
  version = "48";
  pyproject = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit version;
    hash = "sha256-NoqffTF+faQtKR9RuBTpWAgl230+twJrDUdCe/rSPi8=";
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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
