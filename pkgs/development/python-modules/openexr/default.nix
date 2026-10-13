{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  pkgs,
  cmake,
  ninja,
  numpy,
  pybind11,
  scikit-build-core,
  imath,
}:

buildPythonPackage {
  pname = "openexr";
  inherit (pkgs.openexr) version src;
  pyproject = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">=" \
      --replace-fail "cmake.targets" "build.targets"
  '';

  cmakeFlags = [
    "-DOPENEXR_FORCE_INTERNAL_IMATH=OFF"
  ];

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    imath
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "src/wrappers/python/tests"
  ];

  pythonImportsCheck = [
    "OpenEXR"
  ];

  meta = {
    description = "Python bindings for the OpenEXR image file format";
    inherit (pkgs.openexr.meta) homepage changelog license;
    maintainers = with lib.maintainers; [ ambossmann ];
  };
}
