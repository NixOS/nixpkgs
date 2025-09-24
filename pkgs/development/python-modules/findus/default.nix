{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  adafruit-ampy,
  pyserial,
  plotly,
  pandas,
  dash,
  dash-bootstrap-components,
  dash-ag-grid,
  matplotlib,
  scipy,
}:

buildPythonPackage rec {
  pname = "findus";
  version = "1.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MKesenheimer";
    repo = "fault-injection-library";
    tag = version;
    hash = "sha256-kMe0TzY5N9PJRHKQ3xNKyh/LKsUwCLImNnG3omLiLoo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    adafruit-ampy
    pyserial
    plotly
    pandas
    dash
    dash-bootstrap-components
    dash-ag-grid
    matplotlib
    scipy
  ];

  pythonImportsCheck = [ "findus" ];

  meta = {
    description = "Python library to perform fault-injection attacks on microcontrollers";
    homepage = "https://github.com/MKesenheimer/fault-injection-library";
    changelog = "https://github.com/MKesenheimer/fault-injection-library/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "analyzer";
  };
}
