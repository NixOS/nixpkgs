{
  lib,
  stdenv,
  buildPythonPackage,
  equihash,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "pyequihash";
  pyproject = true;

  inherit (equihash)
    version
    src
    ;

  sourceRoot = "${src.name}/python";

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace ./equihash/__init__.py --replace-fail \
        "ctypes.util.find_library('equihash') or ctypes.util.find_library('libequihash')" "'${lib.getLib equihash}/lib/libequihash${soext}'"
    '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "equihash" ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test.py

    runHook postCheck
  '';

  meta = {
    inherit (equihash.meta)
      description
      homepage
      license
      teams
      ;
  };
}
