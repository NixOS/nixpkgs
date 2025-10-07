{
  callPackage,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  bottle,
  certifi,
  filelock,
  isodate,
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

  sphinxHook,
  sphinx-autodoc2,
  myst-parser,
  sphinx-copybutton,
  furo,

  pytestCheckHook,
  boto3,
}:

# ideally we'd use finalAttrs.finalPackage instead of lib.fix for self-reference,
# but buildPythonPackage doesn't support it yet
lib.fix (
  self:
  buildPythonPackage rec {
    pname = "arelle${lib.optionalString (!gui) "-headless"}";
    version = "2.37.59";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Arelle";
      repo = "Arelle";
      tag = version;
      hash = "sha256-ao4OKe3e1V3Df7396gVn4nqmpKNAbs5ny2y/GsxQwcE=";
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

    build-system = [
      setuptools
      setuptools-scm
    ];

    dependencies = [
      bottle
      certifi
      filelock
      isodate
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
      pytestCheckHook
      boto3
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    disabledTestPaths = [
      "tests/integration_tests"
    ]
    ++ lib.optionals (!gui) [
      # these tests import tkinter
      "tests/unit_tests/arelle/test_updater.py"
      "tests/unit_tests/arelle/test_import.py"
    ];

    passthru.hasGUI = gui;

    passthru.tests = {
      cli = callPackage ./test-cli.nix { arelle = self; };
    };

    meta = {
      changelog = "https://github.com/Arelle/Arelle/releases/tag/${src.tag}";
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
)
