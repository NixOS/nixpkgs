{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  opencv-python,
  simsimd,
  stringzilla,
}:

buildPythonPackage rec {
  pname = "albucore";
  version = "0.0.21";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    rev = "refs/tags/${version}";
    hash = "sha256-bIsJ9o1gPCGJZXrzZbRXzS3ZQURcRaWmGBQZsAdX0eg=";
  };

  pythonRelaxDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv-python
    simsimd
    stringzilla
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
