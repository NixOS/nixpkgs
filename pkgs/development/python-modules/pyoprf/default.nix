{
  lib,
  stdenv,
  buildPythonPackage,
  liboprf,
  setuptools,
  pysodium,
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
    '';

  sourceRoot = "${src.name}/python";

  build-system = [ setuptools ];

  dependencies = [
    pysodium
    securestring
  ];

  pythonImportsCheck = [ "pyoprf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/test.py" ];

  meta = {
    inherit (liboprf.meta)
      description
      homepage
      changelog
      license
      teams
      ;
  };
}
