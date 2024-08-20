{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  cmake,
  ninja,
  pybind11,
  scikit-build-core,
  numpy,
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "37";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit version;
    hash = "sha256-bf9fzkr8rbSSu/fLIJCFctmb3DKqK+qGgbrPtpsqqG0=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ] ++ scikit-build-core.optional-dependencies.pyproject;

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
