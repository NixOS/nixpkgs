{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  gremlinpython,
  hatchling,
  jsonpath-ng,
  moto,
  openpyxl,
  opensearch-py,
  pandas,
  pg8000,
  progressbar2,
  pyarrow,
  pymysql,
  pyodbc,
  pyparsing,
  pytestCheckHook,
  redshift-connector,
  requests-aws4auth,
  setuptools,
  sparqlwrapper,
}:

buildPythonPackage rec {
  pname = "awswrangler";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-pandas";
    tag = version;
    hash = "sha256-MkoJpztVjwZbGcJTdnLRF7ZtIFd0qGoz/cksEoqLe4w=";
  };

  pythonRelaxDeps = [
    "packaging"
    "pyarrow"
  ];

  build-system = [ hatchling ];

  dependencies = [
    boto3
    gremlinpython
    jsonpath-ng
    openpyxl
    opensearch-py
    pandas
    pg8000
    progressbar2
    pyarrow
    pymysql
    redshift-connector
    requests-aws4auth
    setuptools
  ];

  optional-dependencies = {
    sqlserver = [ pyodbc ];
    sparql = [ sparqlwrapper ];
  };

  nativeCheckInputs = [
    moto
    pyparsing
    pytestCheckHook
  ];

  pythonImportsCheck = [ "awswrangler" ];

  enabledTestPaths = [
    # Subset of tests that run in upstream CI (many others require credentials)
    # https://github.com/aws/aws-sdk-pandas/blob/20fec775515e9e256e8cee5aee12966516608840/.github/workflows/minimal-tests.yml#L36-L43
    "tests/unit/test_metadata.py"
    "tests/unit/test_session.py"
    "tests/unit/test_utils.py"
    "tests/unit/test_moto.py"
  ];

  meta = with lib; {
    description = "Pandas on AWS";
    homepage = "https://github.com/aws/aws-sdk-pandas";
    changelog = "https://github.com/aws/aws-sdk-pandas/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
