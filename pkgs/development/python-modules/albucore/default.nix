{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  opencv-python,
  stringzilla,
}:

buildPythonPackage rec {
  pname = "albucore";
  version = "0.0.19";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    rev = "refs/tags/${version}";
    hash = "sha256-GwT7Py7pKbpHxx4avj37/hRjSJXdH5uBU11nCITysVw=";
  };

  pythonRelaxDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv-python
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
