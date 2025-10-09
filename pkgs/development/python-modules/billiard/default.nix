{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  psutil,
}:

buildPythonPackage rec {
  pname = "billiard";
  version = "4.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "billiard";
    tag = "v${version}";
    hash = "sha256-KUA1ydRoDIALhapDPG4c0C4q0Z72MReHeFCqqGviCNw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [ "billiard" ];

  disabledTests = [
    # time sensitive
    "test_on_ready_counter_is_synchronized"
  ];

  meta = {
    description = "Python multiprocessing fork with improvements and bugfixes";
    homepage = "https://github.com/celery/billiard";
    changelog = "https://github.com/celery/billiard/blob/${src.tag}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
