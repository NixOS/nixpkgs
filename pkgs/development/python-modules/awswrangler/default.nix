{ backoff
, sparqlwrapper
, boto3
, buildPythonPackage
, fetchFromGitHub
, gremlinpython
, jsonpath-ng
, lib
, moto
, openpyxl
, opensearch-py
, pandas
, pg8000
, poetry-core
, progressbar2
, pyarrow
, pymysql
, pyodbc
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, redshift-connector
, requests-aws4auth
}:

buildPythonPackage rec {
  pname = "awswrangler";
  version = "2.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-pandas";
    rev = "refs/tags/${version}";
    hash = "sha256-xUEytEgr/djfnoOowLxAZmbPkMS+vU0fuPY7JxZXEe0=";
  };

  nativeBuildInputs = [ poetry-core pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    backoff
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
  ];

  pythonRelaxDeps = [
    "gremlinpython"
    "numpy"
    "openpyxl"
    "pandas"
    "pg8000"
    "pyarrow"
  ];

  nativeCheckInputs = [ moto pytestCheckHook ];

  pytestFlagsArray = [
    # Subset of tests that run in upstream CI (many others require credentials)
    # https://github.com/aws/aws-sdk-pandas/blob/2b7c62ac0762b1303149bb3c03979791479ba4f9/.github/workflows/minimal-tests.yml
    "tests/test_metadata.py"
    "tests/test_session.py"
    "tests/test_utils.py"
    "tests/test_moto.py"
  ];

  passthru.optional-dependencies = {
    sqlserver = [ pyodbc ];
    sparql = [ sparqlwrapper ];
  };

  meta = {
    description = "Pandas on AWS";
    homepage = "https://github.com/aws/aws-sdk-pandas";
    changelog = "https://github.com/aws/aws-sdk-pandas/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
