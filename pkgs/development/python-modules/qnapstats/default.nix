{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, xmltodict
, responses
, python
}:

buildPythonPackage rec {
  pname = "qnapstats";
  version = "0.4.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "colinodell";
    repo = "python-qnapstats";
    rev = version;
    hash = "sha256-Tzi2QG1Xw12fLVfV49SPJKdz5VdJ4hQMuCHH8gxcOBE=";
  };

  propagatedBuildInputs = [
    requests
    xmltodict
  ];

  checkInputs = [
    responses
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test-models.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "qnapstats" ];

  meta = {
    description = "Python API for obtaining QNAP NAS system stats";
    homepage = "https://github.com/colinodell/python-qnapstats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
