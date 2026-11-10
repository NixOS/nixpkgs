{
  lib,
  buildPythonPackage,
  dep-scan,

  # build
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds-xbom-lib";
  inherit (dep-scan) version src;
  pyproject = true;

  sourceRoot = "${src.name}/packages/xbom-lib";

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "xbom_lib" ];

  # no tests
  doCheck = false;

  meta = {
    description = "xBOM library for owasp depscan";
    inherit (dep-scan.meta)
      homepage
      license
      maintainers
      teams
      ;
  };
}
