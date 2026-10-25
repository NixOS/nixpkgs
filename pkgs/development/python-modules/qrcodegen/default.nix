{
  lib,
  buildPythonPackage,
  qrcodegen,
  setuptools,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "qrcodegen";
  pyproject = true;

  inherit (qrcodegen)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "qrcodegen" ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} qrcodegen-demo.py

    runHook postCheck
  '';

  meta = {
    inherit (qrcodegen.meta)
      description
      homepage
      license
      maintainers
      platforms
      ;
  };
})
