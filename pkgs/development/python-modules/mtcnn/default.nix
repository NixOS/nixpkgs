{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  keras,
  nose3,
  opencv4,
  pythonOlder,
}:

buildPythonPackage {
  pname = "mtcnn";
  version = "0.1.1";
  format = "setuptools";

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
      --replace-fail "opencv-python>=4.1.0" ""\
      --replace-fail "tests_require=['nose']," ""

    # https://github.com/tensorflow/tensorflow/issues/15736
    substituteInPlace mtcnn/network/factory.py \
      --replace-fail "tensorflow." ""
  '';

  nativeCheckInputs = [ nose3 ];
  propagatedBuildInputs = [
    keras
    opencv4
  ];

  pythonImportsCheck = [ "mtcnn" ];

  meta = with lib; {
    description = "MTCNN face detection implementation for TensorFlow, as a PIP package";
    homepage = "https://github.com/ipazc/mtcnn";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
