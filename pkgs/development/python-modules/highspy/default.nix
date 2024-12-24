{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
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

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Linear optimization software";
    homepage = "https://github.com/ERGO-Code/HiGHS";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
