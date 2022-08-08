{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pysigma-pipeline-sysmon
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pysigma-backend-qradar";
  version = "0.1.9";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nNipsx-Sec";
    repo = "pySigma-backend-qradar";
    rev = "v${version}";
    hash = "sha256-b3e8cVrVFZgihhEk6QlUnRZigglczHUa/XeMvMzNYLk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  checkInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.backends.qradar"
  ];

  meta = with lib; {
    description = "Library to support Qradar for pySigma";
    homepage = "https://github.com/nNipsx-Sec/pySigma-backend-qradar";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
