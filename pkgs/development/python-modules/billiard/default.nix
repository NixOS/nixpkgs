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
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c02V0S9cHb5iVmBudRte6+xm5sMDh0FdqvAbrsGryaA=";
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
    changelog = "https://github.com/celery/billiard/blob/v${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
