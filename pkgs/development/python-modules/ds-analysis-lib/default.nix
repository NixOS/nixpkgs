{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  appthreat-vulnerability-db,
  custom-json-diff,
  cvss,
  rich,
  toml,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "ds-analysis-lib";
  version = "6.0.0b3";
  pyproject = true;

  # pypi because library is embedded into another project's repo
  src = fetchPypi {
    inherit version;
    pname = "ds_analysis_lib";
    hash = "sha256-XZZzAxQJk65Xoq6z2OadlHUN0REYTjKmSvwz17tvVqc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appthreat-vulnerability-db
    custom-json-diff
    cvss
    rich
    toml
  ];

  pythonImportsCheck = [ "analysis_lib" ];

  # relies on data files that pypi doesn't include
  disabledTestPaths = [
    "tests/test_analysis.py"
    "tests/test_csaf.py"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Analysis library for owasp depscan";
    homepage = "https://pypi.org/project/ds-analysis-lib/";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.ngi ];
    license = with lib.licenses; [ mit ];
  };
}
