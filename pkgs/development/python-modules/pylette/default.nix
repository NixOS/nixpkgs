{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  scikit-learn,
  typer,
  requests,
  pillow,
  numpy,
  pytestCheckHook,
  opencv-python,
  requests-mock,
}:
buildPythonPackage rec {
  pname = "pylette";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qTipTip";
    repo = "Pylette";
    tag = version;
    hash = "sha256-xIaNxSV7hxoaXDha0P+Mj40KY2fViFiw+uNpwXvdwnI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    scikit-learn
    pillow
    requests
    typer
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
  ];

  nativeCheckInputs = [
    opencv-python
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
