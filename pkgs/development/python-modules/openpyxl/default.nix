{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder

# dependencies
, et-xmlfile

# tests
, lxml
, pandas
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openpyxl";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "openpyxl";
    rev = version;
    hash = "sha256-SWRbjA83AOLrfe6on2CSb64pH5EWXkfyYcTqWJNBEP0=";
  };

  propagatedBuildInputs = [
    et-xmlfile
  ];

  nativeCheckInputs = [
    lxml
    pandas
    pillow
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # broken since lxml 2.12; https://foss.heptapod.net/openpyxl/openpyxl/-/issues/2116
    "--deselect=openpyxl/chart/tests/test_reader.py::test_read"
    "--deselect=openpyxl/comments/tests/test_comment_reader.py::test_read_comments"
    "--deselect=openpyxl/drawing/tests/test_spreadsheet_drawing.py::TestSpreadsheetDrawing::test_ignore_external_blip"
    "--deselect=openpyxl/packaging/tests/test_manifest.py::TestManifest::test_from_xml"
    "--deselect=openpyxl/packaging/tests/test_manifest.py::TestManifest::test_filenames"
    "--deselect=openpyxl/packaging/tests/test_manifest.py::TestManifest::test_exts"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_from_complex"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_merge_named_styles"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_unprotected_cell"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_none_values"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_rgb_colors"
    "--deselect=openpyxl/styles/tests/test_stylesheet.py::TestStylesheet::test_named_styles"
    "--deselect=openpyxl/workbook/external_link/tests/test_external.py::test_read_ole_link"
  ];

  pythonImportsCheck = [
    "openpyxl"
  ];

  meta = with lib; {
    description = "Python library to read/write Excel 2010 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${version}/doc/changes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
