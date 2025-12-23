{
  lib,
  buildPythonPackage,
  qrcodegen,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "qrcodegen";
  pyproject = true;

  inherit (qrcodegen)
    version
    src
    ;

  sourceRoot = "${src.name}/python";

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
}
