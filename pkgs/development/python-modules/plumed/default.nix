{
  lib,
  stdenv,
  buildPythonPackage,
  plumed,

  # build-system
  cython,
  setuptools,

  # tests
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "plumed";
  inherit (plumed) version src;
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/python";

  env = {
    plumed_version = finalAttrs.version;
    plumed_include_dir = "${lib.getDev plumed}/include/plumed/wrapper";

    # Hardcode the path to the kernel so that PLUMED_KERNEL does not need to be set at runtime
    plumed_default_kernel = "${lib.getLib plumed}/lib/libplumedKernel${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    plumed
  ];

  pythonImportsCheck = [ "plumed" ];

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ];

  enabledTestPaths = [ "test" ];

  meta = {
    description = "Python wrappers for plumed";
    homepage = "https://github.com/plumed/plumed2/tree/master/python";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
