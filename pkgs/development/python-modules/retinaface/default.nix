{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gdown,
  keras,
  numpy,
  opencv-python,
  pillow,
  tensorflow,
  tf-keras,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "retinaface";
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "retinaface";
    rev = "refs/tags/v${version}";
    hash = "sha256-0s1CSGlK2bF1F2V/IuG2ZqD7CkNfHGvp1M5C3zDnuKs=";
  };

  # requires internet connection
  disabledTestPaths = [
    "tests/test_actions.py"
    "tests/test_align_first.py"
    "tests/test_expand_face_area.py"
  ];

  build-system = [ setuptools ];

  dependencies = [
    gdown
    keras
    numpy
    opencv-python
    pillow
    tensorflow
    tf-keras
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "retinaface" ];

  meta = {
    description = "Deep Face Detection Library for Python";
    homepage = "https://github.com/serengil/retinaface";
    changelog = "https://github.com/serengil/retinaface/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
