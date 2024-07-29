{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  opencv-python,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tensorflow,
}:

buildPythonPackage {
  pname = "mtcnn";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ipazc";
    repo = "mtcnn";
    # No tags / releases; using commit: https://github.com/ipazc/mtcnn/commit/3208d443a8f01d317c65d7c97a03bc0a6143c41d
    rev = "3208d443a8f01d317c65d7c97a03bc0a6143c41d";
    hash = "sha256-GXUrLJ5XD6V2hT/gjyYSuh/CMMw2xIXKBsYFvQmbLYs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup, setuptools" "setup, find_packages"\
      --replace-fail "setuptools.find_packages" "find_packages"\
      --replace-fail "keras>=2.0.0" ""\
      --replace-fail "tests_require=['nose']," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    opencv-python
    tensorflow
  ];

  pythonImportsCheck = [ "mtcnn" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "MTCNN face detection implementation for TensorFlow";
    homepage = "https://github.com/ipazc/mtcnn";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
