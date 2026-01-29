{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  openjpeg,
  libtiff,
  glibc,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  lxml,
  numpy,
  pillow,

  # tests
  addBinToPathHook,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage (finalAttrs: {
  pname = "glymur";
  version = "0.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = "glymur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6NvXeEk2N7+2LCvgOqq7fF7sgp/5r9uf6Vv5NLEyzA=";
  };

  patches = [
    (replaceVars ./set-lib-paths.patch {
      openjp2_lib = "${lib.getLib openjpeg}/lib/libopenjp2${stdenv.hostPlatform.extensions.sharedLibrary}";
      tiff_lib = "${lib.getLib libtiff}/lib/libtiff${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace glymur/lib/_tiff.py \
        --replace-fail \
          'glymur_config("c")' \
          'ctypes.CDLL("${lib.getLib glibc}/lib/libc.so.6")'
  '';

  __propagatedImpureHostDeps = lib.optional stdenv.hostPlatform.isDarwin "/usr/lib/libc.dylib";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lxml
    numpy
    pillow
  ];

  nativeCheckInputs = [
    addBinToPathHook
    pytestCheckHook
    scikit-image
  ];

  disabledTestPaths = [
    # this test involves glymur's different ways of finding the openjpeg path on
    # fsh systems by reading an .rc file and such, and is obviated by the patch
    "tests/test_config.py"
  ];

  pythonImportsCheck = [ "glymur" ];

  meta = {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    changelog = "https://github.com/quintusdias/glymur/blob/${finalAttrs.src.tag}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
