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
<<<<<<< HEAD
=======
, pythonRelaxDepsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, redshift-connector
, requests-aws4auth
}:

buildPythonPackage rec {
  pname = "awswrangler";
<<<<<<< HEAD
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "2.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-pandas";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Sb5yqbEqGmwhPoG21+uMnl8Jdn3Gc455guceQhAflWY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
=======
    hash = "sha256-xUEytEgr/djfnoOowLxAZmbPkMS+vU0fuPY7JxZXEe0=";
  };

  nativeBuildInputs = [ poetry-core pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    backoff
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  nativeCheckInputs = [
    moto
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Subset of tests that run in upstream CI (many others require credentials)
    # https://github.com/aws/aws-sdk-pandas/blob/20fec775515e9e256e8cee5aee12966516608840/.github/workflows/minimal-tests.yml#L36-L43
    "tests/unit/test_metadata.py"
    "tests/unit/test_session.py"
    "tests/unit/test_utils.py"
    "tests/unit/test_moto.py"
  ];

  passthru.optional-dependencies = {
    sqlserver = [
      pyodbc
    ];
    sparql = [
      sparqlwrapper
    ];
  };

  meta = with lib; {
    description = "Pandas on AWS";
    homepage = "https://github.com/aws/aws-sdk-pandas";
    changelog = "https://github.com/aws/aws-sdk-pandas/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
