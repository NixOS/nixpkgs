{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt5
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anyqt";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ales-erjavec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dL2EUAMzWKq/oN3rXiEC6emDJddmg4KclT5ONKA0jfk=";
  };

  pythonImportsCheck = [ "AnyQt" ];

  doCheck = true;

  checkInputs = [
    pyqt5
    pytestCheckHook
  ];

  # All of these fail because Qt modules cannot be imported
  disabledTestPaths = [
    "tests/test_qabstractitemview.py"
    "tests/test_qaction_set_menu.py"
    "tests/test_qactionevent_action.py"
    "tests/test_qfontdatabase_static.py"
    "tests/test_qpainter_draw_pixmap_fragments.py"
    "tests/test_qsettings.py"
    "tests/test_qstandarditem_insertrow.py"
    "tests/test_qtest.py"
  ];

  meta = with lib; {
    description = "A PyQt/PySide compatibility layer";
    homepage = "https://anyqt.readthedocs.io";
    changelog = "https://github.com/ales-erjavec/anyqt/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
