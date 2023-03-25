{ lib
, buildPythonPackage
, fetchFromGitHub
, ink-extensions
, packaging
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.8.0";
  pname = "plotink";

  src = fetchFromGitHub {
    owner = "evil-mad";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ylaNkG4TB4WlxPUFVh9G30o29Vui/2TNn4bBmdRkLog=";
  };

  propagatedBuildInputs = [
    ink-extensions
    packaging
    pyserial
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # depends on environment variables or special file on disk
    "test_plot_utils.py"
  ];
  pythonImportsCheck = [ "plotink" ];

  meta = with lib; {
    description = "Python helper routines for driving AxiDraw, EggBot, WaterColorBot, and similar plotter-based machines";
    homepage = "https://github.com/evil-mad/plotink";
    license = licenses.mit;
    maintainers = with maintainers; [ sdedovic ];
  };
}
