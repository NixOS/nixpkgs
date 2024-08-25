{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,
  setuptools-scm,

  sphinx,
  sphinx-autodoc2,
  myst-parser,
  sphinx-copybutton,
  furo,

  certifi,
  filelock,
  isodate,
  lxml,
  numpy,
  openpyxl,
  pyparsing,
  python-dateutil,
  regex,
  tkinter,

  pycryptodome,
  pg8000,
  pymysql,
  pyodbc,
  rdflib,
  holidays,
  pytz,
  tinycss2,
  graphviz,
  cheroot,
  cherrypy,
  tornado,

  pytestCheckHook,
  boto3,
}:

buildPythonPackage rec {
  pname = "arelle";
  version = "2.30.25";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "refs/tags/${version}";
    hash = "sha256-xzTrFie97HDIqPZ4nzCh+0p/w0bTK12cS0FSsuIi7tY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
        'requires = ["setuptools~=73.0", "wheel~=0.44", "setuptools_scm[toml]~=8.1"]' \
        'requires = ["setuptools", "wheel", "setuptools_scm[toml]"]'
  '';

  build-system = [
    setuptools
    setuptools-scm

    # docs
    sphinx
    sphinx-autodoc2
    myst-parser
    sphinx-copybutton
    furo
  ];

  dependencies = [
    certifi
    filelock
    isodate
    lxml
    numpy
    openpyxl
    pyparsing
    python-dateutil
    regex
    tkinter
  ];

  optional-dependencies = {
    crypto = [ pycryptodome ];
    db = [
      pg8000
      pymysql
      pyodbc
      rdflib
    ];
    efm = [
      holidays
      pytz
    ];
    esef = [ tinycss2 ];
    objectmaker = [ graphviz ];
    webserver = [
      cheroot
      cherrypy
      tornado
    ];
  };

  # Documentation
  postBuild = ''
    pushd docs
    make html
    mkdir -p $doc/share/doc/arelle
    cp -r _build/* $doc/share/doc/arelle
    popd
  '';

  nativeCheckInputs = [
    pytestCheckHook
    boto3
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    rm -r tests/integration_tests
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Open source XBRL platform";
    mainProgram = "arelle";
    homepage = "http://arelle.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      roberth
      tomasajt
    ];
  };
}
