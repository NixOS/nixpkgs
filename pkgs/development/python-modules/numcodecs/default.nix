{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,
  cython,
  py-cpuinfo,
  pkgconfig,

  # dependencies
  numpy,

  # tests
  msgpack,
  pytestCheckHook,
  importlib-metadata,

  # buildInputs
  c-blosc,
  libzstd,
  liblz4,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o883iB3wiY86nA1Ed9+IEz/oUYW//le6MbzC+iB3Cbw=";
  };

  patches = [
    # A rebased version of:
    # https://github.com/zarr-developers/numcodecs/pull/569
    #
    # From some reason it fails to apply, even when the PR doesn't merge
    # conflict:
    ./system-libs.patch
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    cython
    py-cpuinfo
    pkgconfig
  ];

  propagatedBuildInputs = [ numpy ];

  optional-dependencies = {
    msgpack = [ msgpack ];
    # zfpy = [ zfpy ];
  };

  buildInputs = [
    c-blosc
    libzstd
    liblz4
  ];

  NUMCODECS_USE_SYSTEM_LIBS = 1;
  preBuild = lib.optionalString (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) ''
    export DISABLE_NUMCODECS_AVX2=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    msgpack
    importlib-metadata
  ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  pytestFlagsArray = [ "$out/${python.sitePackages}/numcodecs" ];

  meta = {
    homepage = "https://github.com/zarr-developers/numcodecs";
    license = lib.licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
