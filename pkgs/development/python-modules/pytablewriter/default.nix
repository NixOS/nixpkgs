{
  lib,
  buildPythonPackage,
  dataproperty,
  dominate,
  elasticsearch,
  fetchFromGitHub,
  loguru,
  mbstrdecoder,
  pandas,
  pathvalidate,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools-scm,
  simplejson,
  tabledata,
  tcolorpy,
  toml,
  typepy,
  xlsxwriter,
  xlwt,
}:

buildPythonPackage rec {
  pname = "pytablewriter";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "pytablewriter";
    tag = "v${version}";
    hash = "sha256-YuuSMKTSG3oybvA6TDWNnGg4EiDAw2tRlM0S9mBQlkc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dataproperty
    mbstrdecoder
    pathvalidate
    tabledata
    tcolorpy
    typepy
  ];

  optional-dependencies = {
    all = [
      dominate
      elasticsearch
      loguru
      pandas
      # pytablereader
      pyyaml
      simplejson
      toml
      xlsxwriter
      xlwt
    ];
    es = [ elasticsearch ];
    es8 = [ elasticsearch ];
    excel = [
      xlwt
      xlsxwriter
    ];
    html = [ dominate ];
    logging = [ loguru ];
    # from = [
    #   pytablereader
    # ];
    pandas = [ pandas ];
    # sqlite = [
    #   simplesqlite
    # ];
    # theme = [
    #   pytablewriter-altrow-theme
    # ];
    toml = [ toml ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pathvalidate" ];

  disabledTests = [
    # Circular dependency
    "test_normal_from_file"
    "test_normal_from_text"
    "test_normal_clear_theme"
    # Test compares CLI output
    "test_normal"
  ];

  disabledTestPaths = [
    "test/writer/binary/test_excel_writer.py"
    "test/writer/binary/test_sqlite_writer.py"
    "test/writer/test_elasticsearch_writer.py"
  ];

  meta = {
    description = "Library to write a table in various formats";
    homepage = "https://github.com/thombashi/pytablewriter";
    changelog = "https://github.com/thombashi/pytablewriter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
  };
}
