{ lib
, stdenv
, buildPythonPackage
, substituteAll
, glibc
, libtiff
, openjpeg
, fetchFromGitHub
, lxml
, numpy
, pytestCheckHook
, pythonOlder
, scikit-image
, setuptools
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.13.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = "glymur";
    rev = "refs/tags/v${version}";
    hash = "sha256-GUqe9mdMm2O/cbZw8Reohh4X1kO+xOMWHb83PjNvdu8=";
  };

  patches = [
    (substituteAll {
      src = ./set-lib-paths.patch;
      openjp2_lib = "${lib.getLib openjpeg}/lib/libopenjp2${stdenv.hostPlatform.extensions.sharedLibrary}";
      tiff_lib = "${lib.getLib libtiff}/lib/libtiff${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace glymur/lib/tiff.py \
        --replace-fail "glymur_config('c')" "ctypes.CDLL('${lib.getLib glibc}/lib/libc.so.6')"
  '';

  __propagatedImpureHostDeps = lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

  build-system = [
    setuptools
  ];

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

  pythonImportsCheck = [
    "glymur"
  ];

  meta = {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    changelog = "https://github.com/quintusdias/glymur/blob/v${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
