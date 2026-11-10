{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  scikit-build-core,
  pybind11,
  numpy,
  cmake,
  ninja,
  pathspec,
  highs,
}:
buildPythonPackage {
  pname = "highspy";
  version = highs.version;
  pyproject = true;

  inherit (highs) src;

  build-system = [
    cmake
    ninja
    pathspec
    scikit-build-core
    pybind11
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ numpy ];

  pythonImportsCheck = [ "highspy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Linear optimization software";
    homepage = "https://github.com/ERGO-Code/HiGHS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
