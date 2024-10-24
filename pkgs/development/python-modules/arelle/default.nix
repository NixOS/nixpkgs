{
  lib,
  buildPythonPackage,
  certifi,
  cheroot,
  cherrypy,
  fetchFromGitHub,
  filelock,
  graphviz,
  gui ? true,
  holidays,
  isodate,
  lxml,
  numpy,
  openpyxl,
  pg8000,
  pillow,
  pycryptodome,
  pymysql,
  pyodbc,
  pyparsing,
  python-dateutil,
  python,
  pythonOlder,
  pytz,
  rdflib,
  regex,
  setuptools-scm,
  setuptools,
  sphinx,
  tinycss2,
  tkinter ? null,
  tornado,
  wheel,
  ...
}:

buildPythonPackage rec {
  pname = "arelle${lib.optionalString (!gui) "-headless"}";
  version = "2.33.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "refs/tags/${version}";
    hash = "sha256-gUuPnjdY+2k4711zUgEMJT+Ln4Raubfes1iE7TKG4WU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=73.0" "setuptools" \
      --replace-fail "wheel~=0.44" "wheel"
  '';

  outputs = [
    "out"
    #"doc"
  ];

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  # Missing dependency
  # nativeBuildInputs = [
  #   autodoc2
  #   sphinx
  # ];

  dependencies = [
    certifi
    filelock
    isodate
    lxml
    numpy
    openpyxl
    pillow
    pyparsing
    python-dateutil
    regex
  ] ++ lib.optionals gui [ tkinter ];

  optional-dependencies = {
    Crypto = [ pycryptodome ];
    DB = [
      pg8000
      pymysql
      pyodbc
      rdflib
    ];
    EFM = [
      holidays
      pytz
    ];
    ESEF = [ tinycss2 ];
    ObjectMaker = [ graphviz ];
    WebServer = [
      cheroot
      cherrypy
      tornado
    ];
  };

  # arelle-gui is useless without GUI dependencies, so delete it when !gui.
  postInstall =
    lib.optionalString (!gui) ''
      find $out/bin -name "*arelleGUI*" -delete
    ''
    +
      # By default, not the entirety of the src dir is copied. This means we don't
      # copy the `images` dir, which is needed for the GUI version.
      lib.optionalString (gui) ''
        targetDir=$out/${python.sitePackages}
        cp -vr $src/arelle $targetDir
      '';

  # Documentation
  # postBuild = ''
  #   (cd docs && make html && cp -r _build $doc)
  # '';

  doCheck = false;

  meta = with lib; {
    description = "Facility for XBRL";
    longDescription =
      ''
        An open source facility for XBRL, the eXtensible Business Reporting
        Language supporting various standards, exposed through a Python or
        REST API''
      + lib.optionalString gui " and a graphical user interface.";
    homepage = "http://arelle.org/";
    changelog = "https://github.com/Arelle/Arelle/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ roberth ];
    mainProgram = "arelleGUI";
    platforms = platforms.all;
  };
}
