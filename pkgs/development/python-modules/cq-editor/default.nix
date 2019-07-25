{ lib
, buildPythonPackage
, fetchFromGitHub
, cadquery
, Logbook
, qt5
, pyqt5
, pyparsing
, pyqtgraph
, spyder
, pathpy
, qtconsole
, requests
, pytest
, pytest-xvfb
, pytest-mock
, pytestcov
, pytest-repeat
, pytest-qt
}:

buildPythonPackage rec {
  pname = "cq-editor";
  version = "0.1RC1";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "CQ-editor";
    rev = version;
    sha256 = "0iwcpnj15s64k16948sakvkn1lb4mqwrhmbxk3r03bczs0z33zax";
  };

  propagatedBuildInputs = [
    cadquery
    Logbook
    pyqt5
    pyparsing
    pyqtgraph
    spyder
    pathpy
    qtconsole
    requests
  ];

  checkInputs = [
    pytest
    pytest-xvfb
    pytest-mock
    pytestcov
    pytest-repeat
    pytest-qt
  ];

  checkPhase = ''
    pytest --no-xvfb
  '';

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "CadQuery GUI editor based on PyQT";
    homepage = https://github.com/CadQuery/CQ-editor;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
