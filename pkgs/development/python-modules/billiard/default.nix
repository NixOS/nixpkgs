{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, case
, psutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "billiard";
  version = "4.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jUFd+FrDG5dXlxJaxIZJL+TF5OJx07DfdWHrI0YsmwM=";
  };

  checkInputs = [
    case
    psutil
    pytestCheckHook
  ];

  disabledTests = [
    # psutil.NoSuchProcess: process no longer exists (pid=168)
    "test_set_pdeathsig"
  ];

  pythonImportsCheck = [
    "billiard"
  ];

  meta = with lib; {
    description = "Python multiprocessing fork with improvements and bugfixes";
    homepage = "https://github.com/celery/billiard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
