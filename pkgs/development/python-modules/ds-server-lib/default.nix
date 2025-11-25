{
  lib,
  buildPythonPackage,
  dep-scan,

  # build
  setuptools,

  # deps
  appthreat-vulnerability-db,
  custom-json-diff,
  ds-analysis-lib,
  quart,
  rich,

  # test
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "ds-server-lib";
  inherit (dep-scan) version src;
  pyproject = true;

  sourceRoot = "${src.name}/packages/server-lib";

  build-system = [
    setuptools
  ];

  dependencies = [
    appthreat-vulnerability-db
    custom-json-diff
    ds-analysis-lib
    quart
    rich
  ];

  pythonImportsCheck = [ "server_lib" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  meta = {
    description = "Server library for owasp depscan";
    inherit (dep-scan.meta)
      homepage
      license
      maintainers
      teams
      ;
  };
}
