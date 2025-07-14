{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  attrs,
  chardet,
  humanize,
  isodate,
  jinja2,
  jsonschema,
  marko,
  petl,
  pydantic,
  python-dateutil,
  python-slugify,
  pyyaml,
  requests,
  rfc3986,
  simpleeval,
  tabulate,
  typer,
  typing-extensions,
  validators,

  # Optional formats
  boto3,
  google-api-python-client,
  datasette,
  duckdb,
  duckdb-engine,
  sqlalchemy,
  pygithub,
  pyquery,
  ijson,
  jsonlines,
  pymysql,
  ezodf,
  lxml,
  pandas,
  pyarrow,
  fastparquet,
  psycopg,
  psycopg2,
  visidata,
  tatsu,

  # Tests
  pytestCheckHook,
  pytest-cov,
  pytest-dotenv,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-timeout,
  pytest-vcr,
  moto,
  requests-mock,

  # Tests depending on excel
  openpyxl,
  xlrd,
}:

buildPythonPackage rec {
  pname = "frictionless";
  version = "5.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frictionlessdata";
    repo = "frictionless-py";
    tag = "v${version}";
    hash = "sha256-svspEHcEw994pEjnuzWf0FFaYeFZuqriK96yFAB6/gI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    attrs
    chardet
    humanize
    isodate
    jinja2
    jsonschema
    marko
    petl
    pydantic
    python-dateutil
    python-slugify
    pyyaml
    requests
    rfc3986
    simpleeval
    tabulate
    typer
    typing-extensions
    validators
  ];

  optional-dependencies = {
    # The commented-out formats require dependencies that have not been packaged
    # They are intentionally left in for reference - Please do not remove them
    aws = [
      boto3
    ];
    bigquery = [
      google-api-python-client
    ];
    #ckan = [
    #  frictionless-ckan-mapper # not packaged
    #];
    datasette = [
      datasette
    ];
    duckdb = [
      duckdb
      duckdb-engine
      sqlalchemy
    ];
    #excel = [
    #  openpyxl
    #  tableschema-to-template # not packaged
    #  xlrd
    #  xlwt
    #];
    github = [
      pygithub
    ];
    #gsheets = [
    #  pygsheets # not packaged
    #];
    html = [
      pyquery
    ];
    json = [
      ijson
      jsonlines
    ];
    mysql = [
      pymysql
      sqlalchemy
    ];
    ods = [
      ezodf
      lxml
    ];
    pandas = [
      pandas
      pyarrow
    ];
    parquet = [
      fastparquet
    ];
    postgresql = [
      psycopg
      psycopg2
      sqlalchemy
    ];
    #spss = [
    #  savreaderwriter # not packaged
    #];
    sql = [
      sqlalchemy
    ];
    visidata = [
      # Not ideal: This is actually outside pythonPackages set and depends on whatever
      # Python version the top-level python3Packages set refers to
      visidata
    ];
    wkt = [
      tatsu
    ];
    #zenodo = [
    #  pyzenodo3 # not packaged
    #];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-dotenv
    pytest-lazy-fixtures
    pytest-mock
    pytest-timeout
    pytest-vcr
    moto
    requests-mock

    # We do not have all packages for the `excel` format to fully function,
    # but it's required for some of the tests.
    openpyxl
    xlrd
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    # Requires optional dependencies that have not been packaged (commented out above)
    # The tests of other unavailable formats are auto-skipped
    "frictionless/formats/excel"
    "frictionless/formats/spss"
  ];

  pythonImportsCheck = [
    "frictionless"
  ];

  meta = {
    description = "Data management framework for Python that provides functionality to describe, extract, validate, and transform tabular data";
    homepage = "https://github.com/frictionlessdata/frictionless-py";
    changelog = "https://github.com/frictionlessdata/frictionless-py/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
