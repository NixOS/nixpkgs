{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  scipy,
  numpy,
  pydoe,

  # tests
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pwlf";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cjekel";
    repo = "piecewise_linear_fit_py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RBGOQTvnLm0XdIfDItce38Cdt8+tYr7SL0QzTbkS/fQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    scipy
    numpy
    pydoe
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pwlf" ];

  meta = {
    description = "Fit piecewise linear data for a specified number of line segments";
    homepage = "https://jekel.me/piecewise_linear_fit_py/";
    changelog = "https://github.com/cjekel/piecewise_linear_fit_py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
