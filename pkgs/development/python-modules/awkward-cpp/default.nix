{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cmake,
  ninja,
  pybind11,
  scikit-build-core,

  # dependencies
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "awkward-cpp";
  version = "54";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit (finalAttrs) version;
    hash = "sha256-yVeygEvmp7oouZbEywC3RGJNS3jehGHvd4j4+OUCgo4=";
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
})
