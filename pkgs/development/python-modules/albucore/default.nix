{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  opencv4,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "albucore";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    rev = "refs/tags/${version}";
    hash = "sha256-6c6QiChP3SLTEj1SKlb/AcjQbLX4L9Fdlxem70cxiXM=";
  };

  pythonRemoveDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv4
    typing-extensions
  ];

  pythonImportsCheck = [ "albucore" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "High-performance image processing library to optimize and extend Albumentations with specialized functions for image transformations";
    homepage = "https://github.com/albumentations-team/albucore";
    changelog = "https://github.com/albumentations-team/albucore/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
