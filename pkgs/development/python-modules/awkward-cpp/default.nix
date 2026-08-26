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

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "awkward-cpp";
  version = "56";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit (finalAttrs) version;
    hash = "sha256-zTY1+rkmxmMMCoXZK1mhWFHE9aiB6nSZhAaQJ2NPj1I=";
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

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
