{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  db-dtypes,
  google-cloud-bigquery,
  ipykernel,
  ipython,
  ipywidgets,
  pandas,
  pyarrow,
  pydata-google-auth,
  tqdm,

  # testing
  google-cloud-testutils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bigquery-magics";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-bigquery-magics";
    tag = "v${version}";
    hash = "sha256-1Pda8rcvx7CeAuQlBLxTwCmxMnPeLlQi970bgGl97Bo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    db-dtypes
    google-cloud-bigquery
    ipykernel
    ipython
    ipywidgets
    pandas
    pyarrow
    pydata-google-auth
    tqdm
  ];

  nativeCheckInputs = [
    google-cloud-testutils
    pytestCheckHook
  ];

  disabledTestPaths = [
    "samples/"
  ];

  disabledTests = [
    # OSError: pytest: reading from stdin while output is captured
    "test_bigquery_magic"
    # Requires API key
    "est_context_with_no_query_cache_from_context"
  ];

  pythonImportsCheck = [
    "bigquery_magics"
  ];

  meta = {
    description = "Jupyter magics for Google BigQuery";
    homepage = "https://github.com/googleapis/python-bigquery-magics/";
    changelog = "https://github.com/googleapis/python-bigquery-magics/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
