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
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GtLuro4oBT1ym6M3PTTZ1uIQ9uTYvwqcZPkr0FPx7fU=";
  };

  nativeCheckInputs = [
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
