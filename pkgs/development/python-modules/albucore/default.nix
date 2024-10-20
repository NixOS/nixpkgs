{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  opencv4,
  stringzilla,
}:

buildPythonPackage rec {
  pname = "albucore";
  version = "0.0.18";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    rev = "refs/tags/${version}";
    hash = "sha256-rM7j9PFiQx+Znzpj8zCfyJ45D6M7owPBlaLf3IRBwHI=";
  };

  pythonRemoveDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "stringzilla"
  ];

  dependencies = [
    numpy
    opencv4
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
