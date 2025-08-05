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
  version = "0.0.94";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "deepface";
    tag = "v${version}";
    hash = "sha256-jtDj1j2STjoEW6MdQai6ZuRYVmLo0Ga+VPJ01105Byc=";
  };

  postPatch = ''
    # prevent collisions
    substituteInPlace setup.py \
      --replace-fail "data_files=[(\"\", [\"README.md\", \"requirements.txt\", \"package_info.json\"])]," "" \
      --replace-fail "install_requires=requirements," ""

    substituteInPlace deepface/models/face_detection/OpenCv.py \
      --replace-fail "opencv_path = self.__get_opencv_path()" "opencv_path = '/'.join(os.path.dirname(cv2.__file__).split(os.path.sep)[0:-4]) + \"/share/opencv4/haarcascades/\""
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
    changelog = "https://github.com/serengil/deepface/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
