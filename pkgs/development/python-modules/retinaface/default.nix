{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdown,
  numpy,
  opencv4,
  pillow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "retinaface";
  version = "0.0.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serengil";
    repo = "retinaface";
    rev = "refs/tags/v${version}";
    hash = "sha256-0s1CSGlK2bF1F2V/IuG2ZqD7CkNfHGvp1M5C3zDnuKs=";
  };

  postPatch = ''
    # prevent collisions
    substituteInPlace setup.py \
      --replace-fail "data_files=[(\"\", [\"README.md\", \"requirements.txt\", \"package_info.json\"])]," "" \
      --replace-fail "install_requires=requirements," ""
  '';

  # requires internet connection
  disabledTestPaths = [
    "tests/test_actions.py"
    "tests/test_align_first.py"
    "tests/test_expand_face_area.py"
  ];

  build-system = [ setuptools ];

  dependencies = [
    gdown
    numpy
    opencv4
    pillow
    tensorflow
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
