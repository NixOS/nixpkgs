{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

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
  pyzstd,

  # tests
  msgpack,
  pytestCheckHook,
  importlib-metadata,
  zstd,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.16.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U9cFhl+q8KeSfJc683d1MgAcj7tlPeEZwehEYIYU15k=";
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
    pyzstd = [ pyzstd ];
    # zfpy = [ zfpy ];
  };

  preBuild = lib.optionalString (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) ''
    export DISABLE_NUMCODECS_AVX2=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    importlib-metadata
    zstd
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
