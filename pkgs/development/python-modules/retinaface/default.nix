{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdown,
  keras,
  numpy,
  opencv4,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "retinaface";
  version = "0.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "retinaface";
    rev = "v${version}";
    hash = "sha256-0s1CSGlK2bF1F2V/IuG2ZqD7CkNfHGvp1M5C3zDnuKs=";
  };

  postPatch = ''
    # prevent collisions
    substituteInPlace setup.py \
      --replace-fail "data_files=[(\"\", [\"README.md\", \"requirements.txt\", \"package_info.json\"])]," ""

    # https://github.com/tensorflow/tensorflow/issues/15736
    substituteInPlace retinaface/RetinaFace.py \
      --replace-fail "tensorflow." "tensorflow.python."

    substituteInPlace retinaface/model/retinaface_model.py \
      --replace-fail "tensorflow." "tensorflow.python." \
      --replace-fail "BatchNormalization," "" \
      --replace-fail "# configurations" "from keras.layers import BatchNormalization"
  '';

  checkPhase = ''
    # Require internet connection
    rm tests/test_actions.py
    rm tests/test_align_first.py
    rm tests/test_expand_face_area.py
    runHook pytestCheckPhase
  '';

  propagatedBuildInputs = [
    gdown
    keras
    numpy
    opencv4
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "retinaface" ];

  meta = with lib; {
    description = "Deep Face Detection Library for Python";
    homepage = "https://github.com/serengil/retinaface";
    changelog = "https://github.com/serengil/retinaface/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
