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
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-sysmon";
    rev = "v${version}";
    hash = "sha256-uJgV7emBqQN792EvfOz85BKoZY8DCCr8aUN7Ai8R9js=";
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
