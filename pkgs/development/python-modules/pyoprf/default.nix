{
  lib,
  stdenv,
  buildPythonPackage,
  liboprf,
  setuptools,
  ble-serial,
  pyserial,
  pyserial-asyncio,
  pysodium,
  pyudev,
  securestring,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyoprf";
  pyproject = true;

  inherit (liboprf)
    version
    src
    ;

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace ./pyoprf/__init__.py --replace-fail \
        "ctypes.util.find_library('oprf') or ctypes.util.find_library('liboprf')" "'${lib.getLib liboprf}/lib/liboprf${soext}'"
      substituteInPlace pyoprf/noisexk.py \
        --replace-fail "ctypes.util.find_library('oprf-noiseXK')" "'${lib.getLib liboprf}/lib/liboprf-noiseXK${soext}'" \
        --replace-fail "or ctypes.util.find_library('liboprf-noiseXK')" ""
    '';

  sourceRoot = "${src.name}/python";

  build-system = [ setuptools ];

  dependencies = [
    ble-serial
    pyserial
    pyserial-asyncio
    pysodium
    pyudev
    securestring
  ];

  pythonImportsCheck = [ "pyoprf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/test.py" ];

  meta = {
    homepage = "https://github.com/stef/liboprf/tree/master/python";
    inherit (liboprf.meta)
      description
      changelog
      license
      teams
      ;
  };
}
