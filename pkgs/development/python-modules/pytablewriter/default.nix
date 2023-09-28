{ lib
, buildPythonPackage
, dataproperty
, dominate
, elasticsearch
, fetchFromGitHub
, loguru
, mbstrdecoder
, pandas
, pathvalidate
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, simplejson
, tabledata
, tcolorpy
, toml
, typepy
, xlsxwriter
, xlwt
}:

buildPythonPackage rec {
  pname = "pytablewriter";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VDx7/kKRBho4oWvUXYe5K9CC4vUCDs91G05Wlpa47OE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dataproperty
    mbstrdecoder
    pathvalidate
    tabledata
    tcolorpy
    typepy
  ];

  passthru.optional-dependencies = {
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
    es = [
      elasticsearch
    ];
    es8 = [
      elasticsearch
    ];
    excel = [
      xlwt
      xlsxwriter
    ];
    html = [
      dominate
    ];
    logging = [
      loguru
    ];
    # from = [
    #   pytablereader
    # ];
    pandas = [
      pandas
    ];
    # sqlite = [
    #   simplesqlite
    # ];
    # theme = [
    #   pytablewriter-altrow-theme
    # ];
    toml = [
      toml
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "pathvalidate"
  ];

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

  meta = with lib; {
    description = "A library to write a table in various formats";
    homepage = "https://github.com/thombashi/pytablewriter";
    changelog = "https://github.com/thombashi/pytablewriter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
