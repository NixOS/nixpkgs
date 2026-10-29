{
  lib,
  buildPythonPackage,
  dep-scan,

  # build
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ds-reporting-lib";
  inherit (dep-scan) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/packages/reporting-lib";

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "reporting_lib" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Reporting library for owasp depscan";
    inherit (dep-scan.meta)
      homepage
      license
      maintainers
      teams
      ;
  };
})
