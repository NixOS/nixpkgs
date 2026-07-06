{
  lib,
  stdenv,
  buildPythonPackage,
  libopaque,
  setuptools,
  pysodium,
  python,
}:

buildPythonPackage rec {
  pname = "opaque";
  pyproject = true;

  inherit (libopaque)
    version
    src
    ;

  sourceRoot = "${src.name}/python";

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace ./opaque/__init__.py --replace-fail \
        "ctypes.util.find_library('opaque') or ctypes.util.find_library('libopaque')" "'${lib.getLib libopaque}/lib/libopaque${soext}'"
    '';

  build-system = [ setuptools ];

  dependencies = [ pysodium ];

  pythonImportsCheck = [ "opaque" ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test/simple.py

    runHook postCheck
  '';

  meta = {
    inherit (libopaque.meta)
      description
      homepage
      license
      teams
      ;
  };
}
