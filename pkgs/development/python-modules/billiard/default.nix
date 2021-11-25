{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pytestCheckHook
, case
, psutil
}:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.4.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ismj2p8c66ykpss94rs0bfra5agxxmljz8r3gaq79r8valfb799";
  };

  checkInputs = [
    case
    psutil
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/celery/billiard";
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
