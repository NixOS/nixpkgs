{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  albucore,
  numpy,
  pydantic,
  pyyaml,
  scipy,
  typing-extensions,

  # optional-dependencies
  opencv-contrib-python,
  opencv-python,
  opencv-python-headless,
  huggingface-hub,
  pillow,
  torch,
  pyvips,

  # tests
  deepdiff,
  defusedxml,
  gitMinimal,
  hypothesis,
  pytest-mock,
  pytestCheckHook,
  scikit-image,
  scikit-learn,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "albumentationsx";
  version = "2.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "AlbumentationsX";
    tag = finalAttrs.version;
    hash = "sha256-exCQwduQM29K5Omb48KYIqm2D4yfOKFFEr37zhIvACY=";
  };

  postPatch = ''
    substituteInPlace albumentations/core/analytics/settings.py \
      --replace-fail '"telemetry": True,' '"telemetry": False,'
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    albucore
    numpy
    pydantic
    pyyaml
    scipy
    typing-extensions
  ];

  optional-dependencies = {
    contrib = [
      opencv-contrib-python
    ];
    contrib-headless = [
      # opencv-contrib-python-headless
    ];
    gui = [
      opencv-python
    ];
    headless = [
      opencv-python-headless
    ];
    hub = [
      huggingface-hub
    ];
    pillow = [
      pillow
    ];
    pytorch = [
      torch
    ];
    pyvips = [
      pyvips
    ];
    text = [
      pillow
    ];
  };

  pythonImportsCheck = [ "albumentations" ];

  nativeCheckInputs = [
    deepdiff
    defusedxml
    gitMinimal
    hypothesis
    pillow
    pytest-mock
    pytestCheckHook
    scikit-image
    scikit-learn
    torch
    torchvision
  ];

  disabledTests = [
    # ImportError: cannot import name 'benchmark_coverage' from 'tools'
    "test_direct_script_ignores_unrelated_tools_package"

    # AssertionError: Arrays are not almost equal to 6 decimals
    "test_pca_inverse_transform"
  ];

  disabledTestPaths = [
    # Infinite recursion with albu-spec
    "tests/test_type_consistency.py"

    # Requires unfree google-docstring-parser
    "tests/test_docstrings.py"

    # Fails due to disabling telemetry in postPatch
    "tests/test_telemetry.py"
  ];

  meta = {
    description = "Python library for image augmentation";
    homepage = "https://github.com/albumentations-team/AlbumentationsX";
    changelog = "https://github.com/albumentations-team/AlbumentationsX/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
