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
  version = "57";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "awkward_cpp";
    inherit (finalAttrs) version;
    hash = "sha256-3y//WE1yuZQttutwD6JP6Ji8ZeNp7svNNbz4EmmqQdI=";
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
