{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  joblib,
  keras,
  lz4,
  pythonAtLeast,
  distutils,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mtcnn";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ipazc";
    repo = "mtcnn";
    tag = "v${version}";
    hash = "sha256-gp+jfa1arD3PpJpuRFKIUznV0Lyjt3DPn/HHUviDXhk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    joblib
    lz4
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    distutils
  ];

  pythonImportsCheck = [ "mtcnn" ];

  nativeCheckInputs = [
    keras
    pytestCheckHook
  ];

  disabledTests = [
    # Failing since keras 3.13.0.
    # ValueError: Exception encountered when calling Conv2D.call().
    # The convolution operation resulted in an empty output. Output shape: (0, 48, 48, 3).
    # This can happen if the input is too small for the given kernel size, strides, dilation rate,
    # and padding mode. Please check the input shape and convolution parameters.
    "test_detect_no_faces"
  ];

  meta = {
    description = "MTCNN face detection implementation for TensorFlow";
    homepage = "https://github.com/ipazc/mtcnn";
    changelog = "https://github.com/ipazc/mtcnn/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
