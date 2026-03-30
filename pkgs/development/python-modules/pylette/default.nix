{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  scikit-learn,
  typer,
  typing-extensions,
  requests,
  pillow,
  numpy,
  pytestCheckHook,
  opencv-python,
  requests-mock,
}:
buildPythonPackage rec {
  pname = "pylette";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qTipTip";
    repo = "Pylette";
    tag = version;
    hash = "sha256-BDKJtinSMZQ+6ok9i9IYeCs4XjB44W1zJntXsE/MeGw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    opencv-python
    scikit-learn
    pillow
    requests
    typer
    typing-extensions
    numpy
  ];

  pythonImportsCheck = [
    "Pylette"
  ];

  pythonRelaxDeps = [
    "numpy"
    "Pillow"
    "typer"
  ];

  disabledTests = [
    # hangs forever
    "test_color_extraction_deterministic_kmeans"
    # AssertionError: assert 'Usage: ' in ''
    "test_cli_no_input_is_error"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    typer
  ];

  meta = {
    changelog = "https://github.com/qTipTip/Pylette/releases/tag/${src.tag}";
    description = "Python library for extracting color palettes from images";
    homepage = "https://qtiptip.github.io/Pylette/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
