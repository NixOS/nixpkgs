{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  bottle,
  certifi,
  filelock,
  isodate,
  jaconv,
  jsonschema,
  lxml,
  numpy,
  openpyxl,
  pillow,
  pyparsing,
  python-dateutil,
  regex,
  truststore,
  typing-extensions,

  gui ? true,
  tkinter,

  aniso8601,
  cheroot,
  graphviz,
  holidays,
  matplotlib,
  pg8000,
  pycryptodome,
  pymysql,
  pyodbc,
  pytz,
  rdflib,
  tinycss2,
  tornado,

  sphinxHook,
  sphinx-autodoc2,
  myst-parser,
  sphinx-copybutton,
  furo,

  writableTmpDirAsHomeHook,
  pytestCheckHook,
  boto3,
}:

buildPythonPackage rec {
  pname = "arelle${lib.optionalString (!gui) "-headless"}";
  version = "2.37.72";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    tag = version;
    hash = "sha256-wytYETzntY1sGHgXua/MOkceiNKjr5qddAGWPMJni98=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
        'requires = ["setuptools>=80.9,<81", "wheel>=0.45,<1", "setuptools_scm[toml]>=9.2,<10"]' \
        'requires = ["setuptools", "wheel", "setuptools_scm[toml]"]'
  '';

  pythonRelaxDeps = [
    "pillow" # pillow's current version is above what arelle officially supports, but it should be fine
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bottle
    certifi
    filelock
    isodate
    jaconv
    jsonschema
    lxml
    numpy
    openpyxl
    pillow
    pyparsing
    python-dateutil
    regex
    truststore
    typing-extensions
  ]
  ++ lib.optionals gui [ tkinter ];

  optional-dependencies = {
    crypto = [ pycryptodome ];
    db = [
      pg8000
      pymysql
      pyodbc
      rdflib
    ];
    efm = [
      aniso8601
      holidays
      matplotlib
      pytz
    ];
    esef = [ tinycss2 ];
    objectmaker = [ graphviz ];
    webserver = [
      cheroot
      tornado
    ];
    xule = [ aniso8601 ];
  };

  nativeBuildInputs = [
    # deps for docs
    sphinxHook
    sphinx-autodoc2
    myst-parser
    sphinx-copybutton
    furo
  ];

  # the arelleGUI executable doesn't work when the gui option is false
  postInstall = lib.optionalString (!gui) ''
    find $out/bin -name "*arelleGUI*" -delete
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    boto3
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/integration_tests"
  ]
  ++ lib.optionals (!gui) [
    # these tests import tkinter
    "tests/unit_tests/arelle/test_updater.py"
    "tests/unit_tests/arelle/test_import.py"
  ];

  meta = {
    description = "Open source XBRL platform";
    longDescription = ''
      An open source facility for XBRL, the eXtensible Business Reporting
      Language supporting various standards, exposed through a Python or
      REST API ${lib.optionalString gui " and a graphical user interface"}.
    '';
    mainProgram = "arelle";
    homepage = "http://arelle.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tomasajt
      roberth
    ];
  };
}
