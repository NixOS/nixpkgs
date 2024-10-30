{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  python,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,
  cython,
  py-cpuinfo,

  # dependencies
  numpy,

  # tests
  msgpack,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BdkaQzcz5+7yaNfoDsImoCMtokQolhSo84JpAa7BCY4=";
  };

  patches = [
    # https://github.com/zarr-developers/numcodecs/pull/487
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/zarr-developers/numcodecs/commit/4896680087d3ff1f959401c51cf5aea0fd56554e.patch";
      hash = "sha256-+lMWK5IsNzJ7H2SmLckgxbSSRIIcC7FtGYSBKQtuo+Y=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    cython
    py-cpuinfo
  ];

  propagatedBuildInputs = [ numpy ];

  optional-dependencies = {
    msgpack = [ msgpack ];
    # zfpy = [ zfpy ];
  };

  preBuild = lib.optionalString (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) ''
    export DISABLE_NUMCODECS_AVX2=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    msgpack
  ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  pytestFlagsArray = [ "$out/${python.sitePackages}/numcodecs" ];

  disabledTests = [
    "test_backwards_compatibility"

    "test_encode_decode"
    "test_legacy_codec_broken"
    "test_bytes"

    # ValueError: setting an array element with a sequence. The requested array has an inhomogeneous shape after 1 dimensions. The detected shape was (3,) + inhomogeneous part.
    # with numpy 1.24
    "test_non_numpy_inputs"
  ];

  meta = {
    homepage = "https://github.com/zarr-developers/numcodecs";
    license = lib.licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
