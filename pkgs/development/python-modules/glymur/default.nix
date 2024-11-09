{
  lib,
  stdenv,
  buildPythonPackage,
  substituteAll,
  glibc,
  libtiff,
  openjpeg,
  fetchFromGitHub,
  lxml,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scikit-image,
  setuptools,
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.13.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = "glymur";
    rev = "refs/tags/v${version}";
    hash = "sha256-RzRZuSNvlUrB+J93a1ob7dDMacZB082JwVHQ9Fce2JA=";
  };

  patches = [
    (substituteAll {
      src = ./set-lib-paths.patch;
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
