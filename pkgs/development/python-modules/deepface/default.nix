{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fire,
  flask,
  flask-cors,
  gdown,
  gunicorn,
  keras,
  mtcnn,
  numpy,
  opencv4,
  pandas,
  pillow,
  pythonOlder,
  requests,
  retinaface,
  setuptools,
  tensorflow,
  tqdm,
}:

buildPythonPackage rec {
  pname = "deepface";
  version = "0.0.92";
  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "deepface";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vjm8lfpGyJ7/1CUwIvxXxHqwmv0+iKewYV3vE08gpPQ=";
  };

  postPatch = ''
    # prevent collisions
    substituteInPlace setup.py \
      --replace-fail "data_files=[(\"\", [\"README.md\", \"requirements.txt\", \"package_info.json\"])]," "" \
      --replace-fail "install_requires=requirements," ""

    # https://github.com/tensorflow/tensorflow/issues/15736
    for x in \
      deepface/basemodels/DeepID.py \
      deepface/extendedmodels/Age.py \
      deepface/extendedmodels/Race.py \
      deepface/basemodels/FbDeepFace.py \
      deepface/basemodels/Facenet.py \
      deepface/models/FacialRecognition.py \
      deepface/extendedmodels/Gender.py \
      deepface/models/Demography.py \
      deepface/extendedmodels/Emotion.py \
      deepface/basemodels/ArcFace.py \
      deepface/basemodels/GhostFaceNet.py \
      deepface/basemodels/OpenFace.py \
      deepface/basemodels/VGGFace.py
    do
      substituteInPlace $x \
        --replace-fail "tensorflow.keras" "tensorflow.python.keras"
    done

    substituteInPlace deepface/modules/preprocessing.py \
      --replace-fail "tensorflow." ""

    substituteInPlace deepface/basemodels/OpenFace.py \
      --replace-fail ", BatchNormalization" "" \
      --replace-fail "# pylint: disable=unnecessary-lambda" "from keras.layers import BatchNormalization"

    substituteInPlace deepface/basemodels/ArcFace.py \
      --replace-fail "BatchNormalization," "" \
      --replace-fail "# pylint: disable=too-few-public-methods" "from keras.layers import BatchNormalization"

    substituteInPlace deepface/basemodels/GhostFaceNet.py \
      --replace-fail "BatchNormalization," "" \
      --replace-fail "# pylint: disable=line-too-long, too-few-public-methods, no-else-return, unsubscriptable-object, comparison-with-callable" "from keras.layers import BatchNormalization"

    substituteInPlace deepface/basemodels/Facenet.py \
      --replace-fail "from tensorflow.python.keras.layers import BatchNormalization" "from keras.layers import BatchNormalization" \

    # fix path
    substituteInPlace deepface/detectors/OpenCv.py \
      --replace-fail "opencv_home = cv2.__file__" "opencv_home = os.readlink(cv2.__file__)" \
      --replace-fail "folders = opencv_home.split(os.path.sep)[0:-1]" "folders = opencv_home.split(os.path.sep)[0:-4]" \
      --replace-fail "return path + \"/data/\"" "return path + \"/share/opencv4/haarcascades/\""
  '';

  propagatedBuildInputs = [
    fire
    flask
    flask-cors
    gdown
    gunicorn
    keras
    mtcnn
    numpy
    opencv4
    pandas
    pillow
    requests
    retinaface
    tensorflow
    tqdm
  ];

  # requires internet connection
  doCheck = false;

  pythonImportsCheck = [ "deepface" ];

  meta = {
    description = "Lightweight Face Recognition and Facial Attribute Analysis (Age, Gender, Emotion and Race) Library for Python";
    homepage = "https://github.com/serengil/deepface";
    changelog = "https://github.com/serengil/deepface/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
