{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  opencv4,
  tomli,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "albucore";
  version = "0.0.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    rev = "refs/tags/${version}";
    hash = "sha256-ahW1dRbAFfJQ0B0Nfb+Lco03Ymd/IL6hLGvVox3S8/c=";
  };

  pythonRemoveDeps = [ "opencv-python" ];

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  dependencies = [
    numpy
    opencv4
    tomli
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
