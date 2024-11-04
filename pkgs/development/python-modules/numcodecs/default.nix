{
  lib,
  stdenv,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  setuptools,
  setuptools-scm,
  cython,
  numpy,
  msgpack,
  py-cpuinfo,
  pytestCheckHook,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uk+scDbqWgeMev4dTf/rloUIDULxnJwWsS2thmcDqi4=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
    py-cpuinfo
  ];

  dependencies = [ numpy ];

  optional-dependencies = {
    msgpack = [ msgpack ];
    # zfpy = [ zfpy ];
  };

  preBuild =
    if (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) then
      ''
        export DISABLE_NUMCODECS_AVX2=
      ''
    else
      null;

  nativeCheckInputs = [
    pytestCheckHook
    msgpack
  ];

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

  meta = with lib; {
    homepage = "https://github.com/zarr-developers/numcodecs";
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ ];
  };
}
