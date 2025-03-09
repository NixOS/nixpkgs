{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fire,
  flask,
  flask-cors,
  gdown,
  gunicorn,
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

    substituteInPlace deepface/detectors/OpenCv.py \
      --replace-fail "opencv_home = cv2.__file__" "opencv_home = os.readlink(cv2.__file__)" \
      --replace-fail "folders = opencv_home.split(os.path.sep)[0:-1]" "folders = opencv_home.split(os.path.sep)[0:-4]" \
      --replace-fail "return path + \"/data/\"" "return path + \"/share/opencv4/haarcascades/\""
  '';

  build-system = [ setuptools ];

  dependencies = [
    fire
    flask
    flask-cors
    gdown
    gunicorn
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
