{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
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

  # optional-dependencies
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

  # tests
  moto,
  openpyxl,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-timeout,
  pytest-vcr,
  pytestCheckHook,
  requests-mock,
  xlrd,
  yattag,
}:

buildPythonPackage (finalAttrs: {
  pname = "frictionless";
  version = "5.19.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "frictionlessdata";
    repo = "frictionless-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/l+IXcyraXCwdrM7pWr1hvjiIasDzNUQt+mQAXHS+jM=";
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
    moto
    openpyxl
    pytest-lazy-fixtures
    pytest-mock
    pytest-timeout
    pytest-vcr
    pytestCheckHook
    requests-mock
    xlrd
    yattag
  ]
  # datasette is transitively broken by asgi-csrf
  ++ lib.concatAttrValues (lib.removeAttrs finalAttrs.passthru.optional-dependencies [ "datasette" ]);

  disabledTestPaths = [
    # Requires optional dependencies that have not been packaged (commented out above)
    # The tests of other unavailable formats are auto-skipped
    "frictionless/formats/excel/__spec__/test_mapper.py"
    "frictionless/formats/excel/parsers/__spec__/test_xls.py"
  ];

  disabledTests = [
    # AssertionError: assert 'cp1258' == 'utf-8'
    "test_resource_encoding_detection_accent"

    # UnicodeDecodeError: 'utf-8' codec can't decode byte 0xa9 in position 20: invalid start byte
    "test_remote_loader_latin1"
  ];

  pythonImportsCheck = [ "frictionless" ];

  meta = {
    description = "Data management framework for Python that provides functionality to describe, extract, validate, and transform tabular data";
    homepage = "https://github.com/frictionlessdata/frictionless-py";
    changelog = "https://github.com/frictionlessdata/frictionless-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
    mainProgram = "frictionless";
  };
})
