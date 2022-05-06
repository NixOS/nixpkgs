{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-sysmon";
  version = "0.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-sysmon";
    rev = "v${version}";
    hash = "sha256-Bh0Qh+pY22lm/0vtJC4tFIl1KRF3zFQ8vcH0JEfYGAc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.sysmon"
  ];

  meta = with lib; {
    description = "Library to support Sysmon pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
