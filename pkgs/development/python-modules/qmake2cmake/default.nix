{ lib
, fetchPypi
, fetchFromGitHub
, buildPythonPackage
, packaging
, portalocker
, sympy
, networkx
, xdg
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "unstable-2022-07-06";

  src = fetchFromGitHub {
    # https://github.com/milahu/qmake2cmake/tree/fix-for-pyqt-builder
    # upstream issue https://bugreports.qt.io/browse/QTBUG-104194
    owner = "milahu";
    repo = "qmake2cmake";
    rev = "118ee3bde43aaf0e1f00d9460c52358a88ad4c99";
    sha256 = "XQIQxf9diX5zLOt19pwgowcxhvXA/MQJSGUQE/DgliY=";
  };

  propagatedBuildInputs = [
    packaging
    portalocker
    sympy
    networkx
    xdg
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "qmake2cmake" ];

    meta = with lib; {
      description = "Tool to convert qmake .pro files to CMakeLists.txt	";
      homepage = "https://code.qt.io/cgit/qt/qmake2cmake.git/";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ milahu ];
    };
}
