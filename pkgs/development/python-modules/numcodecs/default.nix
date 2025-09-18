{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,
  cython,
  py-cpuinfo,

  # dependencies
  deprecated,
  numpy,

  # optional-dependencies
  crc32c,

  # tests
  msgpack,
  pytestCheckHook,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xH8g1lZFRWjGtGl84CCB5ru1EvGYc4xqVvr+gCnJf7E=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
    py-cpuinfo
  ];

  dependencies = [
    deprecated
    numpy
  ];

  optional-dependencies = {
    crc32c = [ crc32c ];
    msgpack = [ msgpack ];
    # zfpy = [ zfpy ];
  };

  preBuild = lib.optionalString (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) ''
    export DISABLE_NUMCODECS_AVX2=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    importlib-metadata
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = "pushd $out";
  postCheck = "popd";

  meta = {
    homepage = "https://github.com/zarr-developers/numcodecs";
    license = lib.licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
