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
  twine,
}:

buildPythonPackage (finalAttrs: {
  pname = "findus";
  version = "1.14.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MKesenheimer";
    repo = "fault-injection-library";
    tag = finalAttrs.version;
    hash = "sha256-9jhTzC6XBxmYR8yjwRb/uUARgjmB4WM6WoWmy2aNRbI=";
  };

  build-system = [ setuptools ];

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
    twine
  ];

  pythonImportsCheck = [ "findus" ];

  meta = {
    description = "Python library to perform fault-injection attacks on microcontrollers";
    homepage = "https://github.com/MKesenheimer/fault-injection-library";
    changelog = "https://github.com/MKesenheimer/fault-injection-library/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "analyzer";
  };
})
