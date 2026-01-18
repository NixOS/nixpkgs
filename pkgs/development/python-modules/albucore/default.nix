{
  lib,
  buildPythonPackage,
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
  version = "0.0.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albucore";
    tag = version;
    hash = "sha256-6JXpK8hW296vXnEKjXzeV1cPPOz7sSoKLL/W4EjXC9M=";
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

  # albumentations doesn't support newer versions of albucore
  # and has been archived upstream in favor of relicensed `albumentationsx`
  passthru.skipBulkUpdate = true;

  meta = {
    description = "High-performance image processing library to optimize and extend Albumentations with specialized functions for image transformations";
    homepage = "https://github.com/albumentations-team/albucore";
    changelog = "https://github.com/albumentations-team/albucore/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
