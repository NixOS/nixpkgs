{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # depedencies
  numpy,
  scipy,
  pyqt5,
  matplotlib,
}:

buildPythonPackage {
  pname = "curvefitgui";
  version = "0-unstable-2021-08-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moosepy";
    repo = "curvefitgui";
    rev = "5f1e7f3b95cd77d10bd8183c9a501e47ff94fad7";
    hash = "sha256-oK0ROKxh/91OrHhuufG6pvc2EMBeMP8R5O+ED2thyW8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    pyqt5
    matplotlib
  ];

  pythonImportsCheck = [ "curvefitgui" ];

  meta = {
    description = "Graphical interface to the non-linear curvefit function scipy.optimise.curve_fit";
    homepage = "https://github.com/moosepy/curvefitgui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
