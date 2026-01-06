{
  lib,
  buildPythonPackage,
  dep-scan,

  # build
  setuptools,

  # deps
  appthreat-vulnerability-db,
  custom-json-diff,
  cvss,
  rich,
  toml,

  # test
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "ds-analysis-lib";
  inherit (dep-scan) version src;
  pyproject = true;

  sourceRoot = "${src.name}/packages/analysis-lib";

  build-system = [
    setuptools
  ];

  dependencies = [
    appthreat-vulnerability-db
    custom-json-diff
    cvss
    rich
    toml
  ];

  pythonImportsCheck = [ "analysis_lib" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Analysis library for owasp depscan";
    inherit (dep-scan.meta)
      homepage
      license
      maintainers
      teams
      ;
  };
}
