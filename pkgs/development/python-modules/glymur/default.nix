{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  glibc,
  libtiff,
  lxml,
  numpy,
  openjpeg,
  pytestCheckHook,
  pythonOlder,
  scikit-image,
  setuptools,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.13.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = "glymur";
    tag = "v${version}";
    hash = "sha256-tIvDhlFPpDxC3CgBDT0RN9MM8ycY+J1hjcLXzx14Zhs=";
  };

  patches = [
    # Numpy 2.x compatibility, https://github.com/quintusdias/glymur/pull/675
    (fetchpatch {
      name = "numpy2-compat.patch";
      url = "https://github.com/quintusdias/glymur/commit/89b159299035ebb05776c3b90278f410ca6dba64.patch";
      hash = "sha256-C/Q5WZmW5YtN3U8fxKljfqwKHtFLfR2LQ69Tj8SuIWg=";
    })
    (replaceVars ./set-lib-paths.patch {
      openjp2_lib = "${lib.getLib openjpeg}/lib/libopenjp2${stdenv.hostPlatform.extensions.sharedLibrary}";
      tiff_lib = "${lib.getLib libtiff}/lib/libtiff${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace glymur/lib/tiff.py \
        --replace-fail "glymur_config('c')" "ctypes.CDLL('${lib.getLib glibc}/lib/libc.so.6')"
  '';

  __propagatedImpureHostDeps = lib.optional stdenv.hostPlatform.isDarwin "/usr/lib/libc.dylib";

  build-system = [ setuptools ];

  dependencies = [
    lxml
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scikit-image
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTestPaths = [
    # this test involves glymur's different ways of finding the openjpeg path on
    # fsh systems by reading an .rc file and such, and is obviated by the patch
    "tests/test_config.py"
  ];

  pythonImportsCheck = [ "glymur" ];

  meta = {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    changelog = "https://github.com/quintusdias/glymur/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
