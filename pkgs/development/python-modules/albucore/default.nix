{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  numkong,
  numpy,
  opencv-python,
  stringzilla,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "albucore";
  version = "0.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    tag = finalAttrs.version;
    hash = "sha256-gI6q9ODkc2JoDfV8RA2NzwbC9A6QyZFa7C24prqMydU=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    numkong
    numpy
    opencv-python
    stringzilla
  ];

  pythonImportsCheck = [ "albucore" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # Flaky on some CPUs:
    #   AssertionError: Not equal to tolerance rtol=1e-05, atol=1e-05
    "test_normalize_consistency_across_shapes"
  ];

  meta = {
    description = "High-performance image processing library to optimize and extend Albumentations with specialized functions for image transformations";
    homepage = "https://github.com/albumentations-team/albucore";
    changelog = "https://github.com/albumentations-team/albucore/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
