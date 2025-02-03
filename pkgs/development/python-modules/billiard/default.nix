{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  psutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "billiard";
  version = "4.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "celery";
    repo = "billiard";
    rev = "refs/tags/v${version}";
    hash = "sha256-9LuAlIn6hNiZGvWuaaDQxx9g0aBVF6Z2krxEOrssqRs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [ "billiard" ];

  meta = {
    description = "Python multiprocessing fork with improvements and bugfixes";
    homepage = "https://github.com/celery/billiard";
    changelog = "https://github.com/celery/billiard/blob/v${version}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
