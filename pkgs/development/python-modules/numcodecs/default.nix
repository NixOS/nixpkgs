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

  # dependencies
  deprecated,
  numpy,

  # optional dependencies
  crc32c,
  msgpack,

  # tests
  pytestCheckHook,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AKNkkk/S1gC8zm4s7Za0fEDrX52Ev0sCB6ogjZzmzRw=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
    numpy
    py-cpuinfo
  ];

  dependencies = [
    numpy
    deprecated
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = "pushd $out";
  postCheck = "popd";

  meta = {
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    homepage = "https://github.com/zarr-developers/numcodecs";
    changelog = "https://github.com/zarr-developers/numcodecs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
