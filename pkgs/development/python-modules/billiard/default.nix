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
<<<<<<< HEAD
  version = "4.2.4";
=======
  version = "4.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "billiard";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7DwS3fdYhMNVYR0RIoMFyxNpj56VrGlbF4mIgLKPrOQ=";
=======
    hash = "sha256-Zogy5O/bHymkKMn5zeTltNq/1c1fT7s/YFIDA53dr40=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
