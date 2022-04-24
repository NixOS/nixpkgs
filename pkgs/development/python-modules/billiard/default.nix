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
  version = "3.6.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ismj2p8c66ykpss94rs0bfra5agxxmljz8r3gaq79r8valfb799";
  };

  checkInputs = [
    case
    psutil
    pytestCheckHook
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
