{ buildPythonPackage
, fetchFromGitHub
, lib
, dataproperty
, mbstrdecoder
, pathvalidate
, setuptools
, tabledata
, tcolorpy
, typepy
, pytestCheckHook
, pyyaml
, toml
, elasticsearch
, dominate
}:

buildPythonPackage rec {
  pname = "pytablewriter";
  version = "0.64.2";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+IOHnmdd9g3SoHyITJJtbJ0/SAAmwWmwX5XeqsO34EM=";
  };

  propagatedBuildInputs = [
    dataproperty
    mbstrdecoder
    pathvalidate
    tabledata
    tcolorpy
    typepy
  ];

  checkInputs = [ pyyaml toml elasticsearch dominate ];
  nativeCheckInputs = [ pytestCheckHook ];
  # Circular dependency
  disabledTests = [
    "test_normal_from_file"
    "test_normal_from_text"
    "test_normal_clear_theme"
  ];
  disabledTestPaths = [
    "test/writer/binary/test_excel_writer.py"
    "test/writer/binary/test_sqlite_writer.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/pytablewriter";
    description = "A library to write a table in various formats";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
