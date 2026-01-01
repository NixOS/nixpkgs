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
<<<<<<< HEAD
  pyzstd,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # tests
  msgpack,
  pytestCheckHook,
  importlib-metadata,
<<<<<<< HEAD
  zstd,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "numcodecs";
<<<<<<< HEAD
  version = "0.16.3";
=======
  version = "0.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-U9cFhl+q8KeSfJc683d1MgAcj7tlPeEZwehEYIYU15k=";
=======
    hash = "sha256-xH8g1lZFRWjGtGl84CCB5ru1EvGYc4xqVvr+gCnJf7E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    pyzstd = [ pyzstd ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # zfpy = [ zfpy ];
  };

  preBuild = lib.optionalString (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.avx2Support) ''
    export DISABLE_NUMCODECS_AVX2=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    importlib-metadata
<<<<<<< HEAD
    zstd
  ]
  ++ lib.concatAttrValues optional-dependencies;
=======
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
