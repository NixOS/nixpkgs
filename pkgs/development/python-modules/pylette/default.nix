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
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qTipTip";
    repo = "Pylette";
    tag = version;
    hash = "sha256-i8+QQpYoRfgoV9Nm/FvXSJV+TEvmaaPsPIeG+PU838Q=";
  };

  build-system = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Pillow = \">=9.3,<11.0\"" "Pillow = \"^11\""
    substituteInPlace pyproject.toml \
      --replace-fail "numpy = \"^1.26.4\"" "numpy = \"^2\""
  '';

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

  # Ignoring this test. It's hanging without resolving
  disabledTests = [ "test_color_extraction_deterministic_kmeans" ];

  nativeCheckInputs = [
    opencv-python
    pytestCheckHook
    requests-mock
    typer
  ];

  meta = {
    changelog = "https://github.com/qTipTip/Pylette/releases/tag/${version}";
    description = "Python library for extracting color palettes from images";
    homepage = "https://qtiptip.github.io/Pylette/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
