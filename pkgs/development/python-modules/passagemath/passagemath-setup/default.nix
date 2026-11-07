{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ...
}:
let
  pname = "passagemath-setup";
  snake_pname = "passagemath_setup";
  version = "10.8.13";
  hash = "sha256-kKfUFsmUmvH/BL8NhYuDFdbBUbN34tzK4r0M1mNWKCM=";
in
buildPythonPackage rec {
  inherit pname version;

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [ ];

  src = fetchPypi {
    pname = snake_pname;
    inherit version hash;
  };

  
    postPatch = ''
      cp ${./__init__.py} sage_setup/__init__.py
    '';
 

  pythonImportsCheck = [
    "sage_setup"
  ];

  meta = {
    description = "passagemath: Build system of the Sage library";
    longDescription = ''
      `passagemath-setup` provides the build system of the Sage library,
      based on setuptools.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
